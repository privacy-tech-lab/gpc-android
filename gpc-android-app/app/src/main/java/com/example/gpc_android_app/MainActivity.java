package com.example.gpc_android_app;

import static java.security.AccessController.getContext;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Bundle;
import android.content.ComponentName;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.google.android.material.snackbar.Snackbar;

import java.util.List;


public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    Button btn1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        btn1 = findViewById(R.id.button);
        btn1.setOnClickListener(this);

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

        if (this.hasAdSettings(this)) {
            startActivity(this.adSettings());
        } else {
                /*View vx = getView();
                if (vx != null)*/
            Toast.makeText(this, "Error", Toast.LENGTH_LONG).show();
        }

    }
}