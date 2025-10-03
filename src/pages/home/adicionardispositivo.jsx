import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

// Ícone de Seta para Esquerda (Voltar) - SVG Inline (Copiado do DetalheDispositivo)
const FaArrowLeft = () => (
    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M19 12H5"></path>
        <path d="M12 19l-7-7 7-7"></path>
    </svg>
);

export default function AdicionarDispositivo({ onAddDevice }) {
  const navigate = useNavigate();
  const [name, setName] = useState('');
  const [room, setRoom] = useState('');
  const [token, setToken] = useState('');
  const [suggestions, setSuggestions] = useState(false); // Para o toggle

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!name || !room || !token) {
      alert('Por favor, preencha todos os campos obrigatórios.');
      return;
    }
    
    // Cria o novo objeto dispositivo
    const newDevice = {
      name,
      room,
      type: 'Tomada', // Assumindo 'Tomada' pelo seu formulário
      status: false, // Começa sempre desligado
    };

    // Chama a função passada pelo App.jsx para adicionar o dispositivo
    onAddDevice(newDevice);

    // Redireciona de volta para a tela inicial
    navigate('/');
  };

  return (
    <div className="device-list-container" style={{ padding: '0 15px' }}>
        {/* --- BOTÃO DE VOLTAR ADICIONADO AQUI --- */}
        <div style={{ display: 'flex', justifyContent: 'flex-start', alignItems: 'center', paddingTop: '20px' }}>
            <button 
                onClick={() => navigate(-1)} 
                style={{ 
                    background: 'none', 
                    border: 'none', 
                    color: 'var(--cor-texto-claro)', 
                    fontSize: '20px', 
                    cursor: 'pointer',
                    padding: '0',
                    marginRight: '10px'
                }}
            >
                <FaArrowLeft />
            </button>
        </div>
        {/* --- FIM DO BOTÃO DE VOLTAR --- */}

      {/* Estilos para o texto vermelho (se não estiver no index.css, terá que ser criado) */}
      <h1 style={{ color: '#B42222', fontSize: '24px', fontWeight: 'bold', marginTop: '20px' }}>
        Adicionar novo dispositivo
      </h1>
      
      <h2 style={{ fontSize: '18px', fontWeight: 'bold', marginTop: '15px' }}>
        Cadastre sua tomada Voltrix
      </h2>
      <p style={{ color: '#a4a4a4', fontSize: '14px', marginBottom: '30px' }}>
        Siga as instruções da caixa do seu produto e cadastre o token para conectar com o aplicativo
      </p>

      <form className="device-form" onSubmit={handleSubmit}>
        
        {/* Campo Nome da tomada */}
        <div style={{ marginBottom: '20px' }}>
          <input
            type="text"
            placeholder="Nome da tomada"
            value={name}
            onChange={(e) => setName(e.target.value)}
            className="device-form-input" // Usando classe para estilos de inputs do CSS global
            style={{ border: 'none', boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06)' }}
          />
          <p style={{ fontSize: '12px', color: '#a4a4a4', marginTop: '5px' }}>
            Escolha um nome para sua tomada para o que ela atende. Exemplo: Chuveiro elétrico
          </p>
        </div>

        {/* Campo Local do dispositivo */}
        <div style={{ marginBottom: '20px' }}>
          <input
            type="text"
            placeholder="Local do dispositivo"
            value={room}
            onChange={(e) => setRoom(e.target.value)}
            className="device-form-input" // Usando classe para estilos de inputs do CSS global
            style={{ border: 'none', boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06)' }}
          />
          <p style={{ fontSize: '12px', color: '#a4a4a4', marginTop: '5px' }}>
            Ambiente que o Voltrix estará instalado
          </p>
        </div>

        {/* Campo Token */}
        <div style={{ marginBottom: '30px' }}>
          <input
            type="text"
            placeholder="Token"
            value={token}
            onChange={(e) => setToken(e.target.value)}
            className="device-form-input" // Usando classe para estilos de inputs do CSS global
            style={{ border: 'none', boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06)' }}
          />
          <p style={{ fontSize: '12px', color: '#a4a4a4', marginTop: '5px' }}>
            Verifique e digite o código de Token da caixa do produto Voltrix
          </p>
        </div>

        {/* Toggle Sugestões */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '40px' }}>
          <p style={{ fontWeight: 'bold' }}>Deseja receber sugestões para esse dispositivo?</p>
          {/* Usamos o toggle do CSS que criamos antes */}
          <div 
            className="device-toggle"
            style={{ backgroundColor: suggestions ? '#B42222' : '#d9d9d9' }} // Fundo vermelho para ativo
            onClick={() => setSuggestions(!suggestions)}
          >
            <div 
              className="device-toggle-circle"
              style={{ 
                transform: suggestions ? 'translateX(20px)' : 'translateX(2px)',
                backgroundColor: suggestions ? 'white' : 'white'
              }}
            ></div>
          </div>
        </div>


        {/* Botão Salvar (VERMELHO) */}
        <button 
          type="submit" 
          className="add-device-button"
          style={{ backgroundColor: '#B42222', fontWeight: 'bold' }} // Cor do botão vermelho do seu layout
        >
          SALVAR
        </button>
      </form>

    </div>
  );
}
