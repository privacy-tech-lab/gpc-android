package com.example.gpc_mobile_library;

import android.util.Log;

import java.io.IOException;

import okhttp3.Interceptor;

import okhttp3.Request;
import okhttp3.Response;

public final class GPCInterceptor implements Interceptor {
        @Override public Response intercept(Interceptor.Chain chain) throws IOException {
            Request originalRequest = chain.request();

        Request withGPC = originalRequest.newBuilder()
                .addHeader("Sec-GPC", "1")
                .method(originalRequest.method(), originalRequest.body())
                .build();
        Log.v("success", withGPC.toString());
        return chain.proceed(withGPC);

    }}
