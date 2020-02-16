package com.sqlsorgulari;
import java.lang.Math;
import com.AlertBox.AlertBox;
import com.sun.rowset.CachedRowSetImpl;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.Pane;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;
import javafx.stage.Stage;
import java.sql.*;

public class SQLSorgular {
    private static Connection conn;
    private Connection con;
    private ResultSet rs;
    private Statement st;
    public SQLSorgular() {
        try {
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/OyunForumDB",
                    "postgres", "26272xyz");
        }catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void kullaniciGiris(String kullaniciAdi, String sifre, Stage primaryStage){
        String sorgu = "SELECT * FROM \"OyunForumSchema\".\"Kullanici\"";
        String geciciKullaniciAdi;
        String geciciSifre;
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sorgu);
            while(rs.next()) {
                geciciKullaniciAdi = rs.getString("kullaniciAdi");
                geciciSifre = rs.getString("sifre");
                if((kullaniciAdi.equals(geciciKullaniciAdi)) && (sifre.equals(geciciSifre))){
                    primaryStage.close();
                    AlertBox alertBox= new AlertBox();
                    alertBox.anaMenuyuOlustur(new Stage(), kullaniciAdi, sifre);
                    return;
                }
            }

            rs.close();
            stmt.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public String elemanAra(String elemanAdı) throws SQLException {
        String sorgu = "SELECT \"kullaniciNo\", \"kullanıcıAdı\",\"sifre\" FROM \"OyunForumSchema\".\"personelAra\"('" + elemanAdı + "')";
        String sorguSonucu = "";
        String kullaniciAdi;
        String sifre;
        String profilNo;
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sorgu);
            while(rs.next()) {
                kullaniciAdi = rs.getString("kullanıcıAdı");
                profilNo = rs.getString("kullaniciNo");
                sorguSonucu += "Kullanıcının adı: " + kullaniciAdi +"\n\nKullanıcının Profil No'su: " + profilNo ;
            }

            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sorguSonucu;
    }
    public void mesajlariGoster(String kullaniciAdi) {
        String genelKutuNo = genelKutuNoDondur(kullaniciAdi);
        String sorgu = "SELECT * FROM \"OyunForumSchema\".\"mesajlariGoruntule\"('" + genelKutuNo + "')";
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sorgu);
            while (rs.next()) {
                Label mesaj = new Label();
                Button kapamaTusu = new Button("kapat");
                Scene scene;
                VBox layout;
                mesaj.setText(rs.getString(1));
                Stage window = new Stage();
                window.initModality(Modality.APPLICATION_MODAL);
                window.setTitle("Mesajlar");
                window.setMinWidth(400);
                window.setMinHeight(400);
                kapamaTusu.setOnAction(e->window.close());
                layout = new VBox(10);
                layout.getChildren().addAll(mesaj, kapamaTusu);
                layout.setAlignment(Pos.CENTER);

                scene = new Scene(layout);

                window.setScene(scene);
                window.showAndWait();
                break;
            }
            rs.close();
            stmt.close();
        }catch (Exception e){
            e.printStackTrace();
        }
    }
    public String profilIDDondur(String kullaniciAdi){
        String profilID = null;

        String sorgu;
        sorgu = "select \"profilNumarasi\" FROM \"OyunForumSchema\".\"Kullanici\" WHERE ('" + kullaniciAdi + "')" + "= \"kullaniciAdi\" ";
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sorgu);
            while (rs.next()) {
                profilID = rs.getString(1);
            }
            rs.close();
            stmt.close();
        }catch (Exception e){
            e.printStackTrace();
        }
        return profilID;
    }
    public String kullaniciIDDondur(String kullaniciAdi){
        String kullaniciID = null;

        String sorgu;
        sorgu = "select \"kullaniciID\" FROM \"OyunForumSchema\".\"Kullanici\" WHERE ('" + kullaniciAdi + "')" + "= \"kullaniciAdi\" ";
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sorgu);
            while (rs.next()) {
                kullaniciID = rs.getString(1);
            }
            rs.close();
            stmt.close();
        }catch (Exception e){
            e.printStackTrace();
        }
        return kullaniciID;
    }
    public String genelKutuNoDondur(String kullaniciAdi){
        String genelKNo = null;
        String sorgu;
        sorgu = "select \"genelKutuNo\" FROM \"OyunForumSchema\".\"Kullanici\" WHERE ('" + kullaniciAdi + "')" + "= \"kullaniciAdi\" ";
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sorgu);
            while (rs.next()) {
                genelKNo = rs.getString(1);
            }
            rs.close();
            stmt.close();
        }catch (Exception e){
            e.printStackTrace();
        }
        return genelKNo;
    }
    public String[] profilOzellikleriDondur(String profilID){
        String sorgu = "SELECT \"gercekAd\", \"eposta\",\"age\", \"seviye\" FROM \"OyunForumSchema\".\"Profil\" WHERE ('" + profilID + "')" + "= \"profilNo\"";
        String[] bilgiler = new String[4];
        try{
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sorgu);
            while(rs.next()){
                String ad = rs.getString("gercekAd");
                String oyuncuSeviye = rs.getString("seviye");
                String oyuncuAge = rs.getString("age");
                String oyuncuEposta = rs.getString("eposta");

                bilgiler[0] = ad;
                bilgiler[1] = oyuncuSeviye;
                bilgiler[2] = oyuncuAge;
                bilgiler[3] = oyuncuEposta;
            }
            return bilgiler;
        }catch (Exception e){
            e.printStackTrace();
        }
        return bilgiler;

    }
    public void isimDegistir(String eskiAd, String yeniKullaniciAdi){
        String sorgu = "UPDATE \"OyunForumSchema\".\"Kullanici\" SET \"kullaniciAdi\" = '" + yeniKullaniciAdi + "'" + "WHERE \"kullaniciAdi\" = '" + eskiAd + "'";
        try{
            Statement stmt = conn.createStatement();
            int rs = stmt.executeUpdate(sorgu);

        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public void sifreDegistir(String eskiSifre, String yeniSifre){
        String sorgu = "UPDATE \"OyunForumSchema\".\"Kullanici\" SET \"sifre\" = '" + yeniSifre + "'" + "WHERE \"sifre\" = '" + eskiSifre + "'";
        try{
            Statement stmt = conn.createStatement();
            int rs = stmt.executeUpdate(sorgu);

        }catch (Exception e){
            e.printStackTrace();
        }
    }
    public void seviyeDegistir(String eskiSeviye, String yeniSeviye){
        String sorgu = "UPDATE \"OyunForumSchema\".\"Profil\" SET \"seviye\" = '" + yeniSeviye + "'" + "WHERE \"seviye\" = '" + eskiSeviye + "'";
        try{
            Statement stmt = conn.createStatement();
            int rs = stmt.executeUpdate(sorgu);

        }catch (Exception e){
            e.printStackTrace();
        }
    }
    public void mesajAt(String gonderenAdi, String aliciAdi, String mesaj){
        String genelKutuNo = genelKutuNoDondur(aliciAdi);
        int mesajNumarasi = (int)(Math.random() * 10000) + 1;
        String sorgu = "INSERT INTO \"OyunForumSchema\".\"Mesaj\"(\"mesajNo\",\"mesaj\",\"gonderenAdi\",\"aliciAdi\",\"genelKutuNo\")  VALUES ('" + mesajNumarasi + "','" + mesaj + "','" + gonderenAdi + "','" + aliciAdi + "','" + genelKutuNo + "')";
        try{
            Statement stmt = conn.createStatement();
            stmt.execute(sorgu);

        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public void baslikYaz(String kullaniciAdi, String baslik, String aciklama){

        int baslikNumarasi = (int)(Math.random() * 10000) + 1;
        String kullaniciNo = kullaniciIDDondur(kullaniciAdi);
        String bolum = "B1111";
        String sorgu = "INSERT INTO \"OyunForumSchema\".\"Baslik\"(\"baslikNo\",\"bolumNo\",\"kullaniciID\",\"ad\",\"icerik\") VALUES ('" + baslikNumarasi + "','" + bolum + "','" + kullaniciNo + "','" + baslik + "','" + aciklama + "')";
        try{
            Statement stmt = conn.createStatement();
            stmt.execute(sorgu);

        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public String basliklariAra() throws SQLException {
        String sorgu = "SELECT \"ad\", \"icerik\",\"goruntulenmeSayisi\",\"cevapSayisi\" FROM \"OyunForumSchema\".\"Baslik\"";

        String sorguSonucu = "";
        String ad;
        String icerik;
        String goruntulenmeSayisi;
        String cevapSayisi;
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sorgu);
            while(rs.next()) {
                ad = rs.getString("ad");
                icerik = rs.getString("icerik");
                goruntulenmeSayisi = rs.getString("goruntulenmeSayisi");
                cevapSayisi = rs.getString("cevapSayisi");
                sorguSonucu += "Baslik adi: " + ad + "\nBaslik icerigi: " + icerik +"\nGoruntulenme sayisi " + goruntulenmeSayisi + "\n Cevap Sayisi: " + cevapSayisi + "\n ----------------------------\n" ;
            }

            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sorguSonucu;
    }

}
