const express = require("express");
const path = require("path");
const pool = require("./db");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.static(path.join(__dirname, "..", "frontend")));
app.use("/files", express.static(path.join(__dirname, "..", "data")));

app.get("/api/albumi", async (req, res) => {
    try {
        const rezultat = await pool.query(
            "SELECT * FROM v_albumi_csv"
        );

        res.json(rezultat.rows);
    } catch (error) {
        console.error("Greška pri dohvaćanju podataka:", error.message);

        res.status(500).json({
            greska: "Nije moguće dohvatiti podatke iz baze"
        });
    }
});

app.listen(PORT, () => {
    console.log(`Server je pokrenut na http://localhost:${PORT}`);
});