  var map = L.map('map').setView([0, 0], 13);
  var addresses = [];
  var tableRows = [];
  var bestStationMarker;
  var yellowIcon = L.icon({
    iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-yellow.png',
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41]
  });
  

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: 'Map data &copy; OpenStreetMap contributors'
  }).addTo(map);

  document.getElementById('geocodeButton').addEventListener('click', function() {
    var address = document.getElementById('addressInput').value;
    geocodeAddress(address);
  });

  document.getElementById('findStationButton').addEventListener('click', function() {
    if (addresses.length > 0) {
      var bestStation = findBestStation(addresses);
      displayOutput(bestStation);
      
    } else {
      alert('Please geocode addresses before finding the best station.');
    }
  });

  function geocodeAddress(address) {
    var geocodingUrl = 'https://nominatim.openstreetmap.org/search?format=json&q=' + address;

    axios.get(geocodingUrl)
      .then(function(response) {
        if (response.data && response.data.length > 0) {
          var result = response.data[0];
          var lat = result.lat;
          var lon = result.lon;

          // Display the address on the map
          L.marker([lat, lon]).addTo(map).bindPopup(address).openPopup();
          addresses.push({ address: address, location: { lat: lat, lon: lon } });

          // Zoom the map to the location
          map.setView([lat, lon], 13);

          // Update the table
          if (addresses.length > 1) {
            var bestStation = findBestStation(addresses);
            updateTable(addresses, bestStation);
          }
        } else {
          alert('Address not found');
        }
      })
      .catch(function(error) {
        console.log(error);
        alert('Error occurred during geocoding');
      });
  }

  function findBestStation(addresses) {
    var averageDistances = {}; // Object to store average distances for each address

    // Step 1: Calculate Average Distances
    for (var i = 0; i < addresses.length; i++) {
      var address1 = addresses[i];
      var totalDistance = 0;

      for (var j = 0; j < addresses.length; j++) {
        var address2 = addresses[j];
        var distance = calculateDistance(address1.location, address2.location);
        totalDistance += distance;
      }

      averageDistances[address1.address] = totalDistance / (addresses.length - 1); // Exclude the address itself
    }

    // Step 2: Determine the Best Station
    var bestStation = null;
    var minAverageDistance = Infinity;

    for (var address in averageDistances) {
      if (averageDistances[address] < minAverageDistance) {
        minAverageDistance = averageDistances[address];
        bestStation = addresses.find(a => a.address === address);
      }
    }

    return bestStation;
  }

  function calculateDistance(loc1, loc2) {
    var lat1 = loc1.lat;
    var lon1 = loc1.lon;
    var lat2 = loc2.lat;
    var lon2 = loc2.lon;

    var radlat1 = Math.PI * lat1 / 180;
    var radlat2 = Math.PI * lat2 / 180;
    var radlon1 = Math.PI * lon1 / 180;
    var radlon2 = Math.PI * lon2 / 180;

    var theta = lon1 - lon2;
    var radtheta = Math.PI * theta / 180;
    var dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
    dist = Math.acos(dist);
    dist = dist * 180 / Math.PI;
    dist = dist * 60 * 1.1515;
    dist = dist * 1.609344; // Convert to kilometers

    return dist;
  }

  function updateTable(addresses, bestStation) {
    var tableContainer = document.getElementById('tableContainer');
    tableContainer.innerHTML = '';

    // Create the table
    var table = document.createElement('table');
    var thead = document.createElement('thead');
    var tbody = document.createElement('tbody');

    var headRow = document.createElement('tr');
    var headCell1 = document.createElement('th');
    var headCell2 = document.createElement('th');
    headCell1.textContent = 'Address';
    headCell2.textContent = 'Distance to Best Station (km)';
    headRow.appendChild(headCell1);
    headRow.appendChild(headCell2);
    thead.appendChild(headRow);

    for (var i = 0; i < addresses.length; i++) {
      var addressRow = document.createElement('tr');
      addressRow.id = 'addressRow_' + i;
      var addressCell = document.createElement('td');
      var distanceCell = document.createElement('td');

      var distance = calculateDistance(addresses[i].location, bestStation.location);
      addressCell.textContent = addresses[i].address;
      distanceCell.textContent = distance.toFixed(2);

      addressRow.appendChild(addressCell);
      addressRow.appendChild(distanceCell);
      tbody.appendChild(addressRow);

      // Highlight the best station row
      if (addresses[i].address === bestStation.address) {
        addressRow.classList.add('highlight');
      }

      tableRows[i] = addressRow; // Store the table row for future updates
    }

    table.appendChild(thead);
    table.appendChild(tbody);
    tableContainer.appendChild(table);
  }

  function displayOutput(station) {
    var outputDiv = document.getElementById('output');
    var bestStationAddress = document.getElementById('bestStationAddress');
    var bestStationCoordinates = document.getElementById('bestStationCoordinates');
    var tableContainer = document.getElementById('tableContainer');
  
    outputDiv.innerHTML = '';
    bestStationAddress.innerHTML = '';
    bestStationCoordinates.innerHTML = '';
  
    if (station) {
      var address = station.address;
      var location = station.location;
  
      bestStationAddress.innerHTML = `Best station address: <b>${address}</b>`;
      bestStationCoordinates.textContent = 'Latitude: ' + location.lat + ' | Longitude: ' + location.lon;
  
      // Add CSS class to highlight the address
      bestStationAddress.classList.add('highlight');
  
      outputDiv.appendChild(bestStationAddress);
      outputDiv.appendChild(bestStationCoordinates);
  
      // Remove previous best station marker if exists
      if (bestStationMarker) {
        map.removeLayer(bestStationMarker);
      }
  
      // Create a marker for the address
      var marker = L.marker([location.lat, location.lon], { icon: yellowIcon }).addTo(map).bindPopup(address).openPopup();
  
      // Store the marker for the best station
      bestStationMarker = marker;
  
      // Zoom the map to the best station
      map.setView([location.lat, location.lon], 13);
  
      // Update the table
      updateTable(addresses, station);
    } else {
      outputDiv.innerHTML = '<p>No addresses available to find the best station.</p>';
    }
  }

  
  