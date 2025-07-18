package io.refiner.rn.utils

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.ReadableMapKeySetIterator
import com.facebook.react.bridge.ReadableType
import com.facebook.react.bridge.WritableMap
import org.json.JSONArray
import org.json.JSONObject
import org.json.JSONException

object MapUtil {

    @Throws(JSONException::class)
    fun toJSONObject(readableMap: ReadableMap): JSONObject {
        val jsonObject = JSONObject()
        val iterator: ReadableMapKeySetIterator = readableMap.keySetIterator()

        while (iterator.hasNextKey()) {
            val key = iterator.nextKey()
            val type = readableMap.getType(key)

            when (type) {
                ReadableType.Null -> jsonObject.put(key, null)
                ReadableType.Boolean -> jsonObject.put(key, readableMap.getBoolean(key))
                ReadableType.Number -> jsonObject.put(key, readableMap.getDouble(key))
                ReadableType.String -> jsonObject.put(key, readableMap.getString(key))
                ReadableType.Map -> jsonObject.put(key, toJSONObject(readableMap.getMap(key)))
                ReadableType.Array -> jsonObject.put(key, ArrayUtil.toJSONArray(readableMap.getArray(key)))
            }
        }

        return jsonObject
    }

    @Throws(JSONException::class)
    fun toMap(jsonObject: JSONObject): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>()
        val iterator = jsonObject.keys()

        while (iterator.hasNext()) {
            val key = iterator.next()
            val value = jsonObject.get(key)

            val processedValue = when (value) {
                is JSONObject -> toMap(value)
                is JSONArray -> ArrayUtil.toArray(value)
                else -> value
            }

            map[key] = processedValue
        }

        return map
    }

    fun toMap(readableMap: ReadableMap): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>()
        val iterator: ReadableMapKeySetIterator = readableMap.keySetIterator()

        while (iterator.hasNextKey()) {
            val key = iterator.nextKey()
            val type = readableMap.getType(key)

            val value = when (type) {
                ReadableType.Null -> null
                ReadableType.Boolean -> readableMap.getBoolean(key)
                ReadableType.Number -> readableMap.getDouble(key)
                ReadableType.String -> readableMap.getString(key)
                ReadableType.Map -> toMap(readableMap.getMap(key))
                ReadableType.Array -> ArrayUtil.toArray(readableMap.getArray(key))
            }

            map[key] = value
        }

        return map
    }

    fun toWritableMap(map: Map<String, Any?>): WritableMap {
        val writableMap = Arguments.createMap()

        map.forEach { (key, value) ->
            when (value) {
                null -> writableMap.putNull(key)
                is Boolean -> writableMap.putBoolean(key, value)
                is Double -> writableMap.putDouble(key, value)
                is Int -> writableMap.putInt(key, value)
                is String -> writableMap.putString(key, value)
                is Map<*, *> -> writableMap.putMap(key, toWritableMap(value as Map<String, Any?>))
                is Array<*> -> writableMap.putArray(key, ArrayUtil.toWritableArray(value))
                else -> writableMap.putNull(key)
            }
        }

        return writableMap
    }
} 