package com.twt.service.push

import android.content.Intent
import android.net.Uri

const val BASEURL = "twtstudio://weipeiyang.app/"

// 这么写的原因是： sendBroadcast 中有 intentFilter.matchData 中要求至少要有 scheme
// 所以在 data 前添加一段url 不然无法识别
object IntentUtil {
    fun messageData(data: String): Intent {
        val uri = Uri.parse("${BASEURL}push?")
        val intent = Intent(WbyPushPlugin.DATA, uri)
        intent.putExtra("data", data)
        return intent
    }

    fun cid(cid: String): Intent {
        val uri = Uri.parse("${BASEURL}cid?")
        val intent = Intent(WbyPushPlugin.CID, uri)
        intent.putExtra("cid", cid)
        return intent
    }
}

enum class IntentEvent(val type: Int) {
    FeedbackPostPage(1),
    FeedbackSummaryPage(2),
    MailBox(3),
    SchedulePage(4),
    Update(5),
}