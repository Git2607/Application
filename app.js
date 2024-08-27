import React, { useState } from 'react';

function App() {
  const [trackingNumber, setTrackingNumber] = useState('');
  const [status, setStatus] = useState(null);

  const handleInputChange = (e) => {
    setTrackingNumber(e.target.value);
  };

  const handleSearch = () => {
    // Appel à l'API pour vérifier le statut du colis
    fetch(`https://api.exemple.com/track?number=${trackingNumber}`)
      .then(response => response.json())
      .then(data => setStatus(data.status))
      .catch(error => console.error('Erreur:', error));
  };

  return (
    <div style={{ padding: '20px', maxWidth: '400px', margin: '0 auto' }}>
      <h1>Vérification de Colis</h1>
      <input
        type="text"
        value={trackingNumber}
        onChange={handleInputChange}
        placeholder="Entrez le numéro de suivi"
        style={{
          padding: '10px',
          width: '100%',
          marginBottom: '10px',
          borderRadius: '5px',
          border: '1px solid #ccc'
        }}
      />
      <button
        onClick={handleSearch}
        style={{
          padding: '10px',
          width: '100%',
          backgroundColor: '#007BFF',
          color: '#fff',
          border: 'none',
          borderRadius: '5px',
          cursor: 'pointer'
        }}
      >
        Rechercher
      </button>
      {status && (
        <div style={{ marginTop: '20px', fontSize: '18px' }}>
          <strong>Status:</strong> {status}
        </div>
      )}
    </div>
  );
}

export default App;
