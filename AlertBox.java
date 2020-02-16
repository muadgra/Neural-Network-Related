package com.AlertBox;
import com.sqlsorgulari.SQLSorgular;
import java.sql.*;
import com.sqlsorgulari.*;
import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.Pane;
import javafx.scene.layout.StackPane;
import javafx.stage.Stage;
import javafx.geometry.Pos;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.scene.control.Label;

import java.sql.SQLException;

public class AlertBox {

    public static void kullaniciGirisEkraniOlustur(Stage primaryStage){
        Pane layout = new Pane();
        Button girisButonu = new Button();
        girisButonu.setText("giris");
        Label isim = new Label("Kullanici adi: ");
        Label sifre = new Label("Sifre: ");
        isim.setLayoutX(25);
        isim.setLayoutY(25);
        sifre.setLayoutX(25);
        sifre.setLayoutY(70);
        girisButonu.setLayoutX(100);
        girisButonu.setLayoutY(120);
        TextField isimGiris = new TextField();
        PasswordField sifreGiris = new PasswordField();
        isimGiris.setLayoutX(100);
        isimGiris.setLayoutY(25);
        sifreGiris.setLayoutX(100);
        sifreGiris.setLayoutY(70);
        girisButonu.setOnAction(e -> new SQLSorgular().kullaniciGiris(isimGiris.getText(), sifreGiris.getText(), primaryStage));

        SQLSorgular sqlSorgular = new SQLSorgular();
        layout.getChildren().addAll(isimGiris, sifreGiris, isim, sifre, girisButonu);
        Scene scene = new Scene(layout,300, 250);
        primaryStage.setTitle("Kullanici Giris Ekrani");
        primaryStage.setScene(scene);
        primaryStage.show();
    }
    public static void anaMenuyuOlustur(Stage primaryStage, String kullaniciAdi, String sifre) throws SQLException {
        Pane layout;
        Button bilgiButton;
        Stage window;
        Label label1;
        Label kullaniciAdTutucu = new Label(kullaniciAdi);
        kullaniciAdTutucu.setLayoutX(400);
        kullaniciAdTutucu.setLayoutY(25);
        TextField textField;
        SQLSorgular sqlSorgular = new SQLSorgular();
        textField = new TextField();
        label1 = new Label();
        label1.setText("Kullanici adi: ");
        label1.setLayoutX(20);
        label1.setLayoutY(100);
        textField.setMaxSize(100,50);
        textField.setLayoutX(100);
        textField.setLayoutY(100);
        Button profilButton = new Button("Profili Duzenle");
        profilButton.setOnAction(e->profilDuzenle(kullaniciAdi, sifre));
        profilButton.setLayoutX(350);
        profilButton.setLayoutY(100);
        window = primaryStage;

        Label baslikAdiGiriniz = new Label("Baslik Adi: ");
        baslikAdiGiriniz.setLayoutX(15);
        baslikAdiGiriniz.setLayoutY(370);

        Label baslikIcerikGiriniz = new Label("Baslik Icerigi: ");
        baslikIcerikGiriniz.setLayoutX(15);
        baslikIcerikGiriniz.setLayoutY(400);

        TextField baslikAdTextField = new TextField();
        baslikAdTextField.setLayoutX(100);
        baslikAdTextField.setLayoutY(370);

        TextField baslikIcerikTextField = new TextField();
        baslikIcerikTextField.setLayoutX(100);
        baslikIcerikTextField.setLayoutY(400);

        Button baslikAcButonu = new Button("Baslik Ac");
        baslikAcButonu.setLayoutX(100);
        baslikAcButonu.setLayoutY(425);
        baslikAcButonu.setOnAction(e->sqlSorgular.baslikYaz(kullaniciAdi, baslikAdTextField.getText(), baslikIcerikTextField.getText()));

        Button mesajGoruntuleButton = new Button("Mesajlari Goruntule");
        mesajGoruntuleButton.setLayoutX(350);
        mesajGoruntuleButton.setLayoutY(50);
        mesajGoruntuleButton.setOnAction(e-> sqlSorgular.mesajlariGoster(kullaniciAdi));

        Button basliklariGoruntule = new Button("Basliklari Goruntule");
        basliklariGoruntule.setLayoutX(350);
        basliklariGoruntule.setLayoutY(150);
        basliklariGoruntule.setOnAction(e-> {
            try {
                basliklariGoruntule();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        });

        bilgiButton = new Button("bilgileri goruntule");
        bilgiButton.setLayoutX(100);
        bilgiButton.setLayoutY(140);
        bilgiButton.setOnAction(e-> {
            try {
                AlertBox.display(sqlSorgular.elemanAra(textField.getText()));
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        });

        Label kimeMesaj = new Label("Gonderilecek Kullanici");
        kimeMesaj.setLayoutX(15);
        kimeMesaj.setLayoutY(250);

        TextField gonderilecekKisiTextField = new TextField();
        gonderilecekKisiTextField.setLayoutX(150);
        gonderilecekKisiTextField.setLayoutY(250);

        Label mesajGonder = new Label("Mesaj");
        mesajGonder.setLayoutX(15);
        mesajGonder.setLayoutY(290);

        TextField gonderilecekMesaj = new TextField();
        gonderilecekMesaj.setLayoutX(150);
        gonderilecekMesaj.setLayoutY(290);

        Button mesajGonderButonu = new Button("Mesaji Gonder");
        mesajGonderButonu.setLayoutX(15);
        mesajGonderButonu.setLayoutY(320);
        mesajGonderButonu.setOnAction(e-> sqlSorgular.mesajAt(kullaniciAdi, gonderilecekKisiTextField.getText(), gonderilecekMesaj.getText()));

        layout = new Pane();
        layout.getChildren().addAll(textField,bilgiButton, mesajGoruntuleButton, label1, kullaniciAdTutucu,
                profilButton, kimeMesaj,mesajGonder,gonderilecekKisiTextField, gonderilecekMesaj,
                baslikAdiGiriniz,baslikIcerikGiriniz,baslikIcerikTextField,baslikAdTextField,mesajGonderButonu,
                baslikAcButonu,basliklariGoruntule);
        Scene scene = new Scene(layout, 500, 500);
        window.setTitle("Kullanici Paneli");
        window.setScene(scene);
        window.show();
    }
    public static void display(String mesaj){
        Label bilgiler;
        Button kapamaTusu;
        Scene scene;
        VBox layout;

        Stage window = new Stage();
        window.initModality(Modality.APPLICATION_MODAL);
        window.setTitle("Kullaniciya ait bilgi ekrani");
        window.setMinWidth(350);
        window.setMinHeight(200);
        bilgiler = new Label(mesaj);
        kapamaTusu = new Button("Kapat");
        kapamaTusu.setOnAction(e -> window.close());

        layout = new VBox(10);
        layout.getChildren().addAll(bilgiler, kapamaTusu);
        layout.setAlignment(Pos.CENTER);

        scene = new Scene(layout);

        window.setScene(scene);
        window.showAndWait();
    }
    public static void profilDuzenle(String kullaniciAdi, String sifre){

        SQLSorgular sqlSorgular = new SQLSorgular();
        String profilID = sqlSorgular.profilIDDondur(kullaniciAdi);
        String[] bilgiler = sqlSorgular.profilOzellikleriDondur(profilID);
        Label gercekAd, seviye, yas, eposta;

        gercekAd = new Label(bilgiler[0]);
        gercekAd.setLayoutX(15);
        gercekAd.setLayoutY(15);

        seviye = new Label(bilgiler[1]);
        seviye.setLayoutX(15);
        seviye.setLayoutY(45);

        TextField yeniSeviye = new TextField();
        yeniSeviye.setPromptText(seviye.getText());
        yeniSeviye.setLayoutX(100);
        yeniSeviye.setLayoutY(45);

        Button seviyeDegistir = new Button("Degistir");
        seviyeDegistir.setLayoutX(250);
        seviyeDegistir.setLayoutY(45);
        seviyeDegistir.setOnAction(e->sqlSorgular.seviyeDegistir(seviye.getText(), yeniSeviye.getText()));

        yas = new Label(bilgiler[2]);
        yas.setLayoutX(15);
        yas.setLayoutY(75);

        eposta = new Label(bilgiler[3]);
        eposta.setLayoutX(15);
        eposta.setLayoutY(105);

        Label kullaniciAdEtiket = new Label("Kullanici adiniz:");
        kullaniciAdEtiket.setLayoutX(15);
        kullaniciAdEtiket.setLayoutY(135);

        TextField kullaniciAd = new TextField();
        kullaniciAd.setPromptText(kullaniciAdi);
        kullaniciAd.setLayoutX(100);
        kullaniciAd.setLayoutY(135);

        Button kullaniciAdDegistir = new Button("Degistir");
        kullaniciAdDegistir.setLayoutX(250);
        kullaniciAdDegistir.setLayoutY(135);
        kullaniciAdDegistir.setOnAction(e-> sqlSorgular.isimDegistir(kullaniciAdi, kullaniciAd.getText()));
        Label kullaniciSifreEtiket = new Label("Sifreniz:");
        kullaniciSifreEtiket.setLayoutX(15);
        kullaniciSifreEtiket.setLayoutY(165);

        TextField kullaniciSifre = new TextField();
        kullaniciSifre.setLayoutX(100);
        kullaniciSifre.setLayoutY(165);

        Button sifreDegistir = new Button("Degistir");
        sifreDegistir.setLayoutX(250);
        sifreDegistir.setLayoutY(165);
        sifreDegistir.setOnAction(e->sqlSorgular.sifreDegistir(sifre, kullaniciSifre.getText()));



        Stage primaryStage = new Stage();
        Pane layout = new Pane();
        layout.getChildren().addAll(kullaniciAdEtiket,kullaniciAd,
                kullaniciSifre,kullaniciSifreEtiket, gercekAd, seviye
                ,yas,eposta, kullaniciAdDegistir,seviyeDegistir,
                yeniSeviye, sifreDegistir);
        Scene scene = new Scene(layout, 400,400);
        primaryStage.setScene(scene);
        primaryStage.showAndWait();
    }
    public static void basliklariGoruntule() throws SQLException {
        SQLSorgular sqlSorgular = new SQLSorgular();
        String yazi = sqlSorgular.basliklariAra();
        Stage window = new Stage();
        Pane layout = new Pane();
        Label bilgiler = new Label(yazi);
        bilgiler.setLayoutX(15);
        bilgiler.setLayoutY(15);
        layout.getChildren().add(bilgiler);
        Scene scene = new Scene(layout,500,500);
        window.setScene(scene);
        window.showAndWait();
    }
}
