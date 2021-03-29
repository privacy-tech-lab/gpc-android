import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

import com.example.gpclibrary.R;

public class SettingsActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportFragmentManager()
                .beginTransaction()
                .replace(R.id.layout, new SettingsFragment())
                .commit();
    }
}