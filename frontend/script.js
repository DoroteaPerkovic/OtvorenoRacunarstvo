const API_URL = "/api/albumi";

var albums = [];
var searchForm = document.getElementById("searchForm");
var table = document.getElementById("tableBody");
var downloadCSV = document.getElementById("downloadCSV");
var downloadJSON = document.getElementById("downloadJSON");

$.ajax({
  method: "GET",
  url: API_URL,
  success: function (response) {
    albums = response;
    loadTable(albums);
    console.log(albums);
  },
});

function loadTable(data) {
  for (var i = 0; i < data.length; i++) {
    var row = `<tr>
            <td>${data[i].album_id}</td>
            <td>${data[i].naziv_albuma}</td>
            <td>${data[i].godina}</td>
            <td>${data[i].jezik}</td>
            <td>${data[i].ocjena}</td>
            <td>${data[i].izvodac}</td>
            <td>${data[i].drzava_izvodaca}</td>
            <td>${data[i].godina_osnutka_izvodaca}</td>
            <td>${data[i].zanrovi}</td>
            <td>${data[i].redni_broj_pjesme}</td>
            <td>${data[i].naslov_pjesme}</td>
            <td>${data[i].trajanje_pjesme_s}</td>
        </tr>`;
    table.innerHTML += row;
  }
}

function getColumnIndex(attribute) {
  switch (attribute) {
    case "album_id":
      return 0;
    case "naziv_albuma":
      return 1;
    case "godina":
      return 2;
    case "jezik":
      return 3;
    case "ocjena":
      return 4;
    case "izvodac":
      return 5;
    case "drzava_izvodaca":
      return 6;
    case "godina_osnutka_izvodaca":
      return 7;
    case "zanrovi":
      return 8;
    case "redni_broj_pjesme":
      return 9;
    case "naslov_pjesme":
      return 10;
    case "trajanje_pjesme_s":
      return 11;
    default:
      return 0;
  }
}

searchForm.addEventListener("submit", function (event) {
  event.preventDefault(); //onemoguci osvjezivanje stranice
  const txtValue = document.getElementById("searchInput").value.toUpperCase();
  const filter = document.getElementById("searchAttribute").value;

  var tr = table.getElementsByTagName("tr");
  for (i = 0; i < tr.length; i++) {
    var match = false;
    if (filter === "all") {
      let rowText = tr[i].textContent.toUpperCase();
      if (rowText.includes(txtValue)) {
        match = true;
      }
    } else {
      let columnIndex = getColumnIndex(filter);
      let td = tr[i].getElementsByTagName("td")[columnIndex];
      if (td) {
        let searchValue = td.textContent || td.innerText;
        if (searchValue.toUpperCase().includes(txtValue)) {
          match = true;
        }
      }
    }
    if (match) {
      tr[i].style.display = "";
    } else {
      tr[i].style.display = "none";
    }
  }
});

searchForm.addEventListener("reset", function () {
  setTimeout(function () {
    const tr = document.getElementById("tableBody").getElementsByTagName("tr");
    for (let i = 0; i < tr.length; i++) {
      tr[i].style.display = "";
    }
  }, 10);
});

downloadCSV.addEventListener("click", function () {
  const headers = [
    "ID albuma",
    "Naziv albuma",
    "Godina",
    "Jezik",
    "Ocjena",
    "Izvođač",
    "Država izvođača",
    "Godina osnutka izvođača",
    "Žanrovi",
    "Redni broj pjesme",
    "Naslov pjesme",
    "Trajanje pjesme (s)",
  ];

  let csvContent = "\uFEFF" + headers.join(";") + "\n";
  const rows = tableBody.getElementsByTagName("tr");

  for (let i = 0; i < rows.length; i++) {
    if (rows[i].style.display !== "none") {
      const cells = rows[i].getElementsByTagName("td");
      let rowData = [];

      for (let j = 0; j < cells.length; j++) {
        let text = cells[j].textContent.replace(/"/g, '""');
        rowData.push(`${text}`);
      }
      csvContent += rowData.join(",") + "\n";
    }
  }
  const blob = new Blob([csvContent], { type: "text/csv;charset=utf-8;" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");

  link.setAttribute("href", url);
  link.setAttribute("download", "filtrirani_albumi.csv");
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
});

const downloadJSONBtn = document.getElementById("downloadJSON");

downloadJSONBtn.addEventListener("click", function () {
  const visibleAlbumIds = new Set();
  const rows = tableBody.getElementsByTagName("tr");

  for (let i = 0; i < rows.length; i++) {
    if (rows[i].style.display !== "none") {
      let albumId = rows[i].getElementsByTagName("td")[0].textContent;
      visibleAlbumIds.add(albumId);
    }
  }

  const groupedAlbumsMap = {};

  albums.forEach(item => {
    if (visibleAlbumIds.has(String(item.album_id))) {
      
      if (!groupedAlbumsMap[item.album_id]) {
        groupedAlbumsMap[item.album_id] = {
          album_id: item.album_id,
          naziv_albuma: item.naziv_albuma,
          godina: item.godina,
          jezik: item.jezik,
          ocjena: item.ocjena,
          izvodac: {
            ime: item.izvodac,
            drzava_izvodaca: item.drzava_izvodaca,
            godina_osnutka_izvodaca: item.godina_osnutka_izvodaca
          },
          zanrovi: typeof item.zanrovi === 'string' 
            ? item.zanrovi.split(';').map(z => z.trim()) 
            : item.zanrovi,
          pjesme: []
        };
      }

      groupedAlbumsMap[item.album_id].pjesme.push({
        redni_broj_pjesme: item.redni_broj_pjesme,
        naslov_pjesme: item.naslov_pjesme,
        trajanje_pjesme_s: item.trajanje_pjesme_s
      });
    }
  });

  const finalJsonData = Object.values(groupedAlbumsMap);

  const jsonString = JSON.stringify(finalJsonData, null, 2);

  const blob = new Blob([jsonString], { type: "application/json;charset=utf-8;" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  
  link.setAttribute("href", url);
  link.setAttribute("download", "filtrirani_albumi.json");
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
});
