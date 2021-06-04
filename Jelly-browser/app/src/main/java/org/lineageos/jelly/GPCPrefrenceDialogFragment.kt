
package org.lineageos.jelly

import android.app.AlertDialog
import android.app.Dialog
import android.os.Bundle
import androidx.fragment.app.DialogFragment
import androidx.preference.PreferenceManager
import org.lineageos.jelly.utils.PrefsUtils


class GPCPreferenceDialogFragment : DialogFragment() {
    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog =
            AlertDialog.Builder(requireContext())
                    .setMessage(getString(R.string.GPC_setting))
                    .setPositiveButton(getString(R.string.yes)) { _, _ ->
                        PreferenceManager.getDefaultSharedPreferences(context).edit().apply {
                            putBoolean("key_GPC", true)
                            putBoolean("key_do_not_track", true)
                            apply()
                        }
                    }
                    .setNegativeButton(getString(R.string.no)) { _, _ -> }
                    .create()


    companion object {
        const val TAG = "DNTDialog"
    }

}


