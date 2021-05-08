package com.example.gpc_mobile_library;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentManager;

import java.io.IOException;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class SendGPC extends AppCompatActivity {


    public static final OkHttpClient client = new OkHttpClient.Builder()
            .addInterceptor(new GPCInterceptor())
            .build();

    public static void send_signal(String url, int GPC)  {


        RequestBody body = new FormBody.Builder()
                .add("Sec-GPC", String.valueOf(GPC))
                .build();

        Request request = new Request.Builder()
                .url(url)
                .post(body)
                .build();

        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                Log.e("error", "request failed");
            }

            @Override
            public void onResponse(Call call, final Response response) throws IOException {
                Log.v("success", request.toString());
                if (!response.isSuccessful()) {
                    throw new IOException("Unexpected code " + response);
                }
            }
            }
            );
    }

    public static int set(int GPC, SharedPreferences sharedPref, FragmentManager fm){

        new GPCPreferences().show(fm, "GPC");
        GPC = sharedPref.getInt(("GPC"), 2);
        return GPC;
    }

    public static void GPC(String url, Context activity, FragmentManager fm){
        SharedPreferences sharedPref = activity.getSharedPreferences(
                "GPC", Context.MODE_PRIVATE);
        int GPC = sharedPref.getInt(("GPC"), 2);
        if(GPC==2) GPC = set(GPC, sharedPref, fm);

        send_signal(url, GPC);
    }


}


