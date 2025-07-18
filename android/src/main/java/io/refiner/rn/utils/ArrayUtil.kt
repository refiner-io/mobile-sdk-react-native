package io.refiner.rn.utils

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableType
import com.facebook.react.bridge.WritableArray
import org.json.JSONArray
import org.json.JSONObject
import org.json.JSONException

object ArrayUtil {

    @Throws(JSONException::class)
    fun toJSONArray(readableArray: ReadableArray): JSONArray {
        val jsonArray = JSONArray()

        for (i in 0 until readableArray.size()) {
            val type = readableArray.getType(i)

            when (type) {
                ReadableType.Null -> jsonArray.put(i, null)
                ReadableType.Boolean -> jsonArray.put(i, readableArray.getBoolean(i))
                ReadableType.Number -> jsonArray.put(i, readableArray.getDouble(i))
                ReadableType.String -> jsonArray.put(i, readableArray.getString(i))
                ReadableType.Map -> jsonArray.put(i, MapUtil.toJSONObject(readableArray.getMap(i)))
                ReadableType.Array -> jsonArray.put(i, toJSONArray(readableArray.getArray(i)))
            }
        }

        return jsonArray
    }

    @Throws(JSONException::class)
    fun toArray(jsonArray: JSONArray): Array<Any?> {
        val array = arrayOfNulls<Any>(jsonArray.length())

        for (i in 0 until jsonArray.length()) {
            val value = jsonArray.get(i)

            val processedValue = when (value) {
                is JSONObject -> MapUtil.toMap(value)
                is JSONArray -> toArray(value)
                else -> value
            }

            array[i] = processedValue
        }

        return array
    }

    fun toArray(readableArray: ReadableArray): Array<Any?> {
        val array = arrayOfNulls<Any>(readableArray.size())

        for (i in 0 until readableArray.size()) {
            val type = readableArray.getType(i)

            val value = when (type) {
                ReadableType.Null -> null
                ReadableType.Boolean -> readableArray.getBoolean(i)
                ReadableType.Number -> readableArray.getDouble(i)
                ReadableType.String -> readableArray.getString(i)
                ReadableType.Map -> MapUtil.toMap(readableArray.getMap(i))
                ReadableType.Array -> toArray(readableArray.getArray(i))
            }

            array[i] = value
        }

        return array
    }

    fun toWritableArray(array: Array<Any?>): WritableArray {
        val writableArray = Arguments.createArray()

        array.forEach { value ->
            when (value) {
                null -> writableArray.pushNull()
                is Boolean -> writableArray.pushBoolean(value)
                is Double -> writableArray.pushDouble(value)
                is Int -> writableArray.pushInt(value)
                is String -> writableArray.pushString(value)
                is Map<*, *> -> writableArray.pushMap(MapUtil.toWritableMap(value as Map<String, Any?>))
                is Array<*> -> writableArray.pushArray(toWritableArray(value))
                else -> writableArray.pushNull()
            }
        }

        return writableArray
    }
} 