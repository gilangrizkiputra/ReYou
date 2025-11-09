package com.example.reyou

import android.app.Activity
import android.os.Bundle
import android.widget.TextView

class LockScreenActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val textView = TextView(this)
        textView.text = "Aplikasi ini sedang dikunci"
        textView.textSize = 22f
        textView.textAlignment = TextView.TEXT_ALIGNMENT_CENTER
        setContentView(textView)
    }
}
