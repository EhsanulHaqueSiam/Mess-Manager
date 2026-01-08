package com.area51.area51

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Home Widget Receiver for Area51 Mess Manager
 * 
 * Displays balance summary on home screen with:
 * - Current balance (color-coded: green positive, red negative)
 * - Mess name
 * - Meal and duty counts
 */
class HomeWidgetReceiver : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.home_widget_layout)
            
            // Get data from shared preferences (set by Flutter)
            val balance = widgetData.getString("balance", "৳0") ?: "৳0"
            val messName = widgetData.getString("messName", "Area51") ?: "Area51"
            val mealsCount = widgetData.getString("mealsCount", "0") ?: "0"
            val dutiesCount = widgetData.getString("dutiesCount", "0") ?: "0"
            
            // Update widget views
            views.setTextViewText(R.id.balance_value, balance)
            views.setTextViewText(R.id.mess_name, messName)
            views.setTextViewText(R.id.meals_count, mealsCount)
            views.setTextViewText(R.id.duties_count, dutiesCount)
            
            // Set balance color based on value (green for positive, red for negative)
            val balanceColor = if (balance.startsWith("-")) {
                0xFFEF4444.toInt() // Red
            } else {
                0xFF10B981.toInt() // Green
            }
            views.setTextColor(R.id.balance_value, balanceColor)
            
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
