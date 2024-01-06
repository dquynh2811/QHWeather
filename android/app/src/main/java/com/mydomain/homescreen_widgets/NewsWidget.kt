package com.mydomain.homescreen_widgets

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import java.io.File
import es.antonborri.home_widget.HomeWidgetPlugin
import com.example.qhweather.R
import android.util.Log
class NewsWidget : AppWidgetProvider() {
    override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray,
    ) {
        Log.d("NewsWidget.kt update ","")
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.news_widget).apply {

                // Retrieve weather information from the plugin
                val cityName = widgetData.getString("city_name", null)
                setTextViewText(R.id.city_name, cityName ?: "No city name")

                val temperature = widgetData.getString("temperature", null)
                setTextViewText(R.id.temperature, temperature ?: "No temperature")

                val feels_like = widgetData.getString("feels_like", null)
                setTextViewText(R.id.feels_like, feels_like ?: "No feels like")

                // Assume that weather icon is represented by an image file
//                if (weatherIconPath != null) {
//                    // Tạo một AppWidgetTarget để hiển thị ảnh trong ImageView của widget
//                    val appWidgetTarget = object : AppWidgetTarget(context, R.id.weather_icon, views, appWidgetId) {
//                        override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
//                            // Khi ảnh đã được tải xong, cập nhật ImageView của widget
//                            super.onResourceReady(resource, transition)
//                            appWidgetManager.updateAppWidget(appWidgetId, views)
//                        }
//                    }
//
//                    // Sử dụng Glide để tải ảnh từ URL và đặt nó vào ImageView của widget
//                    Glide.with(context.applicationContext)
//                            .asBitmap()
//                            .load(weatherIconPath)
//                            .into(appWidgetTarget)
//                } else {
//                    // Nếu không có đường dẫn ảnh, đặt ảnh mặc định
//                    setImageViewResource(R.id.weather_icon, R.mipmap.ic_launcher)
//                }


                val airQuality = widgetData.getString("air_quality", null)
                setTextViewText(R.id.air_quality, airQuality ?: "No air quality")
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}