/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ActivityServlet;


import config.DB;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Fathan Fardian Sanum
 */
@WebServlet(name = "AddActivityServlet", urlPatterns = {"/AddActivityServlet"})
public class AddActivityServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        DB db = new DB(); // Membuat object Koneksi
        
        db.connect(); // Koneksi ke database
        
        // Ambil data dari form
        String namaBarang = request.getParameter("nama");
        String kategori = request.getParameter("kategori");
        double harga = Double.parseDouble(request.getParameter("harga"));
        int stok = Integer.parseInt(request.getParameter("stok"));
        String deskripsi = request.getParameter("deskripsi");
        
        // Buat object barang
        Barang barang = new Barang(namaBarang, kategori, harga, stok, deskripsi);
        
        String query = "INSERT INTO barang (nama_barang, kategori, harga, stok, deskripsi) VALUES ('"+ barang.getNama() +"', '"+ barang.getKategori() +
                "', '"+ barang.getHarga() +"', '"+ barang.getStok() + "', '"+ barang.getDeskripsi()+"' )";
        
        // Simpan ke database
        db.runQuery(query);

        response.sendRedirect("BarangServlet");
    }
}
