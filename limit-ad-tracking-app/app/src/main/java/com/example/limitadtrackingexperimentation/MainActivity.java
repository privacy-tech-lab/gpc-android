package com.example.limitadtrackingexperimentation;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import java.io.IOException;
import android.os.Bundle;
import android.widget.TextView;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MainActivity extends AppCompatActivity {


    TextView adid_provided_display;
    TextView limit_id_display;
    TextView adid_display;
    AdvertisingIdClient.Info adid_info;
    boolean limit_ad_tracking;
    String temp;
    String user_adid;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        adid_provided_display = findViewById(R.id.adid_avaliable);
        limit_id_display = findViewById(R.id.limitadtracking);
        adid_display = findViewById(R.id.adid);

        /*
         * Worker thread to run AdId commands
         */
        ExecutorService service = Executors.newSingleThreadExecutor();
        service.execute(new Runnable() {
            @Override
            public void run() {
                ad_id_testing();
            }
        });

    }

    /*
     * This functions prints the value of Limit Ad Tracking and the actual
     * value of AdId to the screen.
     *
     * Note: Run this function in a worker thread to avoid crashing the app.
     */
    private void ad_id_testing() {
        try {
            adid_info = AdvertisingIdClient.getAdvertisingIdInfo(this);
            limit_ad_tracking = adid_info.isLimitAdTrackingEnabled();

            temp = String.valueOf(limit_ad_tracking);
            limit_id_display.setText(temp);

            user_adid = adid_info.getId();
            adid_display.setText(user_adid);

        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (GooglePlayServicesNotAvailableException e) {
            throw new RuntimeException(e);
        } catch (GooglePlayServicesRepairableException e) {
            throw new RuntimeException(e);
        }
    }

}