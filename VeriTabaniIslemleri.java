package com.vtys;
import com.sqlsorgulari.*;
import javafx.application.Application;
import javafx.stage.Stage;
import com.AlertBox.*;
public class VeriTabaniIslemleri extends Application {
    SQLSorgular sqlSorgular = new SQLSorgular();
    public static void main(String[] args)
    {
        launch(args);
    }
    @Override
    public void start(Stage primaryStage) throws Exception {
        AlertBox alertBox = new AlertBox();
        alertBox.kullaniciGirisEkraniOlustur(primaryStage);
    }
}
