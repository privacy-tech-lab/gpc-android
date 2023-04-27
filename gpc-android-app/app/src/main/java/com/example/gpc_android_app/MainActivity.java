package com.example.gpc_android_app;

import androidx.appcompat.app.AppCompatActivity;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Bundle;
import android.content.ComponentName;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import java.util.List;


public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    Button adid_settings_btn;
    Button brave_browser_btn;
    Button duckgo_browser_btn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        adid_settings_btn = findViewById(R.id.adid_button);
        adid_settings_btn.setOnClickListener(this);

        brave_browser_btn = findViewById(R.id.brave_btn);
        brave_browser_btn.setOnClickListener(this);

        duckgo_browser_btn = findViewById(R.id.duckgo_btn);
        duckgo_browser_btn.setOnClickListener(this);

    }

    /**
     * Check if system ad settings exist
     *
     * @param c Context
     * @return Information if system ad settings exist
     */
    public static boolean hasAdSettings(Context c) {
        return isCallable(c, adSettings());
    }


    /**
     * Returns an intent to the system ad settings
     *
     * @return Intent to open system ad settings
     */
    public static Intent adSettings() {
        Intent intent = new Intent();
        return intent.setComponent(new ComponentName("com.google.android.gms", "com.google.android.gms.ads.settings.AdsSettingsActivity"));
    }

    /**
     * Checks if intent exists
     *
     * @param c      Content
     * @param intent Intent
     * @return Information if intent exists
     */
    public static boolean isCallable(Context c, Intent intent) {
        List<ResolveInfo> list = c.getPackageManager().queryIntentActivities(intent,
                PackageManager.MATCH_DEFAULT_ONLY);
        return list.size() > 0;
    }

    @Override
    public void onClick(View v) {
        /* Redirects user to their AdId settings.
         */
        if (v.getId() == R.id.adid_button) {
            if (hasAdSettings(this)) {
                startActivity(adSettings());
            } else {
                Toast.makeText(this, "Error", Toast.LENGTH_LONG).show();
            }
        }
        /* Opens the brave app in PlayStore using intents; if PlayStore is not installed,
         * redirects user to browser google play.
         */
        else if (v.getId() == R.id.brave_btn) {
            try {
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setData(Uri.parse("market://details?id=com.brave.browser"));
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
            } catch (ActivityNotFoundException e) {
                Log.e("App-log", "Could not find Market");
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setData(Uri.parse("https://play.google.com/store/apps/details?id=com.brave.browser"));
                startActivity(intent);
            }

        }
        /* Opens the duck-duck go app in PlayStore using intents; if PlayStore is not installed,
         * redirects user to browser google play.
         */
        else if (v.getId() == R.id.duckgo_btn) {
            try {
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setData(Uri.parse("market://details?id=com.duckduckgo.mobile.android"));
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
            } catch (ActivityNotFoundException e) {
                Log.e("App-log", "Could not find Market");
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setData(Uri.parse("https://play.google.com/store/apps/details?id=com.duckduckgo.mobile.android"));
                startActivity(intent);
            }
        }

    }
}