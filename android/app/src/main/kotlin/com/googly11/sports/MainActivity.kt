package com.googly11.fantasy
import android.util.Log
import androidx.annotation.NonNull
import com.sabpaisa.gateway.android.sdk.SabPaisaGateway
import com.sabpaisa.gateway.android.sdk.interfaces.IPaymentSuccessCallBack
import com.sabpaisa.gateway.android.sdk.models.TransactionResponsesModel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(), IPaymentSuccessCallBack<TransactionResponsesModel> {

    private val CHANNEL = "com.sabpaisa.integration/native"
    var resultCallback:MethodChannel.Result?=null
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "callSabPaisaSdk") {
                resultCallback = result
//                Toast.makeText(this, "callSabPaisaSdk", Toast.LENGTH_LONG).show()
                val arguments = call.arguments as ArrayList<String>
                val sabPaisaGateway1 =
                    SabPaisaGateway.builder()
                        .setAmount(arguments[4].toDouble())   //Mandatory Parameter
                        .setFirstName(arguments[0]) //Mandatory Parameter
                        .setLastName(arguments[1]) //Mandatory Parameter
                        .setMobileNumber(arguments[3])
                        .setEmailId(arguments[2])//Mandatory Parameter
                        .setSabPaisaPaymentScreen(true)//Mandatory Parameter
                        .setSalutation("")
                        .setClientCode("GGP11")
                        .setAesApiIv("s4cE9ZbOA7w1cJDY")
                        .setAesApiKey("uTR54CMVm1oTC25h")
                        .setTransUserName("Googlygo11_13304")
                        .setTransUserPassword("GGP11_SP13304")
                        .build()
                SabPaisaGateway.setInitUrl("https://securepay.sabpaisa.in/SabPaisa/sabPaisaInit?v=1")
                SabPaisaGateway.setEndPointBaseUrl("https://securepay.sabpaisa.in")
                SabPaisaGateway.setTxnEnquiryEndpoint("https://txnenquiry.sabpaisa.in")
                sabPaisaGateway1.init(this@MainActivity, this)

            } else {
//                Toast.makeText(this, "volla", Toast.LENGTH_LONG).show()
            }
        }
    }

    override fun onPaymentFail(message: TransactionResponsesModel?) {
        Log.d("SABPAISA", "Payment Fail")
        val arrayList = ArrayList<String>()
        arrayList.add(message?.status.toString())
        arrayList.add(message?.clientTxnId.toString())
        resultCallback?.success(arrayList)
    }

    override fun onPaymentSuccess(response: TransactionResponsesModel?) {
        Log.d("SABPAISA", "Payment Success${response?.statusCode}")

        val arrayList = ArrayList<String>()
        arrayList.add(response?.status.toString())
        arrayList.add(response?.clientTxnId.toString())
        resultCallback?.success(arrayList)

    }
}
//package com.example.sabpaisa_android_sdk;
//import android.os.AsyncTask;
//import android.os.Bundle;
//import android.view.View;
//import android.widget.Button;
//import android.widget.EditText;
//import android.widget.TextView;
//import androidx.appcompat.app.AppCompatActivity;
//import org.json.JSONException;
//import org.json.JSONObject;
//import java.io.BufferedReader;
//import java.io.IOException;
//import java.io.InputStream;
//import java.io.InputStreamReader;
//import java.io.OutputStream;
//import java.net.HttpURLConnection;
//import java.net.URL;
//import java.util.HashMap;
//import java.util.Map;
//public class TransEnq extends AppCompatActivity {
//    private EditText editTextClientCode;
//    private EditText editTextClientTxnId;
//    private Button btnSubmit;
//    private TextView textViewResult;
//    private static final String AUTH_KEY = "x0xzPnXsgTq0QqXx";
//    private static final String AUTH_IV = "oLA38cwT6IYNGqb3";
//    @Override protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState); setContentView(R.layout.trans);
//        editTextClientCode = findViewById(R.id.editTextClientCode);
//        editTextClientTxnId = findViewById(R.id.editTextClientTxnId);
//        btnSubmit = findViewById(R.id.btnSubmit);
//        textViewResult = findViewById(R.id.textViewResult);
//        btnSubmit.setOnClickListener(new View.OnClickListener()
//        { @Override public void onClick(View view) {
//            String clientCode = editTextClientCode.getText().toString().trim();
//            String clientTxnId = editTextClientTxnId.getText().toString().trim();
//            new MyAsyncTask().execute(clientCode, clientTxnId); } });
//    }
//    private class MyAsyncTask extends AsyncTask<String, Void, String>
//    { @Override protected String doInBackground(String... params)
//        { String clientCode = params[0]; String clientTxnId = params[1];
//            String encryptedString = null;
//            String query = "clientCode=" + clientCode + "&clientTxnId=" + clientTxnId;
//            try { encryptedString = Encryptor.encrypt(AUTH_KEY, AUTH_IV, query);
//            }
//            catch (Exception e) { e.printStackTrace();
//            }
//            JSONObject jsonObject = new JSONObject();
//            try { jsonObject.put("clientCode", clientCode);
//            }
//            catch (JSONException e) { throw new RuntimeException(e);
//            } try { jsonObject.put("statusTransEncData", encryptedString);
//            }
//            catch (JSONException e) { throw new RuntimeException(e);
//            }
//            String apiUrl = "https://stage-txnenquiry.sabpaisa.in/SPTxtnEnquiry/getTxnStatusByClientxnId";
//            String response = performPostCall(apiUrl, jsonObject.toString());
//            String decryptedString = null;
//            try { JSONObject statusResponse = new JSONObject(response);
//                decryptedString = Encryptor.decrypt(AUTH_KEY, AUTH_IV, statusResponse.getString("statusResponseData"));
//            } catch (Exception e) { e.printStackTrace(); } return decryptedString;
//    } @Override protected void onPostExecute(String result)
//        { textViewResult.setText("DecryptedString: " + result);
//    } } private String performPostCall(String requestURL, String postDataParams)
//    { URL url; StringBuilder response = new StringBuilder(); try { url = new URL(requestURL);
//        HttpURLConnection conn = (HttpURLConnection)
//        url.openConnection(); conn.setRequestMethod("POST");
//        conn.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
//        conn.setRequestProperty("Accept", "application/json");
//        conn.setDoOutput(true); conn.setDoInput(true);
//        OutputStream os = conn.getOutputStream();
//        os.write(postDataParams.getBytes("UTF-8"));
//        os.close(); int responseCode = conn.getResponseCode();
//        if (responseCode == HttpURLConnection.HTTP_OK)
//        { String line; BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
//            while ((line = br.readLine()) != null) { response.append(line); } }
//        else {
//        // Handle the error case // You can use conn.getErrorStream() to get the error response } } catch (IOException e) { e.printStackTrace(); } return response.toString(); } }
//        }
