package com.example.gpc_mobile_library;

import android.util.Log;

import java.io.IOException;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class SendGPC {
    public static void send_signal(String url)  {
        OkHttpClient client = new OkHttpClient();

        Request request = new Request.Builder()
                .url(url)
                .addHeader("GPC-Signal", "1")
                .build();

        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                Log.e("error", "request failed");
            }

            @Override
            public void onResponse(Call call, final Response response) throws IOException {
                Log.e("success", "request succeeded");
                if (!response.isSuccessful()) {
                    throw new IOException("Unexpected code " + response);
                }
            }
            }
            );
    }}
