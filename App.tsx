import React, { useState } from 'react';
import { BrowserRouter as Router, Routes, Route, useLocation } from 'react-router-dom';
// Componentes importados (mantidos)
import Navbar from './components/NavBar.jsx';
import Inicio from './pages/home/inicio.jsx'; 
import AdicionarDispositivo from './pages/home/adicionardispositivo.jsx'; 
import Gastos from './pages/home/gastos.jsx'; 
import Perfil from './pages/home/perfil.jsx';
import Mais from './pages/home/mais.jsx'; 
import DetalheDispositivo from './pages/home/detalhedispositivo.jsx'; 
import Assistente from './pages/home/assistente.jsx';
import Gerenciar from './pages/home/gerenciar.jsx';
// Componentes de Autenticação
import Cadastro from './pages/auth/cadastro.jsx'; 
import Entre from './pages/auth/entre.jsx'; 
import { AuthProvider } from './contexts/UseAuth.jsx'; 

// 📌 Novo import do detalhe do painel solar
import DetalhePainelSolar from './pages/home/detalhepainelsolar.jsx';

import './styles/standard_text.css';

const initialDevices = [
  { id: 1, name: 'Lâmpada Sala', type: 'Lâmpada', status: true, room: 'Sala' },
  { id: 2, name: 'Ar Cond. Quarto', type: 'Ar Condicionado', status: false, room: 'Quarto' },
];

// Componente principal que define a lógica de estado e rotas
function MainAppContent() {
  const location = useLocation();

  // 1. ROTAS ONDE A NAVBAR DEVE SER ESCONDIDA
  const noNavbarRoutes = [
    '/', 
    '/entre',
    '/cadastro',   
    '/adicionar-dispositivo',
    '/gerenciar',
    '/dispositivo/',
    '/painel-solar' // 📌 agora DetalhePainelSolar também não mostra navbar
  ];

  // 2. LÓGICA CONDICIONAL
  const currentPath = location.pathname;
  
  const shouldHideNavbar = noNavbarRoutes.some(route => {
    if (route.endsWith('/') && route.length > 1) {
      return currentPath.startsWith(route);
    }
    return currentPath === route;
  });

  const shouldShowNavbar = !shouldHideNavbar;

  // Estados e Handlers
  const [devices, setDevices] = useState(initialDevices);

  const handleAddDevice = (newDevice) => {
    const deviceWithId = { ...newDevice, id: Date.now(), status: false }; 
    setDevices((prevDevices) => [...prevDevices, deviceWithId]);
  };

  const handleToggleDevice = (id) => {
    setDevices(devices.map(device => 
      device.id === id ? { ...device, status: !device.status } : device
    ));
  };

  const handleRemoveDevice = (idToRemove) => {
    setDevices(devices.filter(device => device.id !== idToRemove));
  };

  return (
    <div 
      className="app-container" 
      style={{ paddingBottom: shouldShowNavbar ? '60px' : '0' }}
    > 
      <div className="page-content">
        <Routes>
          {/* Rotas de autenticação */}
          <Route path="/" element={<Entre />} />
          <Route path="/entre" element={<Entre />} />
          <Route path="/cadastro" element={<Cadastro />} />

          {/* Telas sem navbar */}
          <Route 
            path="/adicionar-dispositivo" 
            element={<AdicionarDispositivo onAddDevice={handleAddDevice} />} 
          />
          <Route 
            path="/dispositivo/:id" 
            element={
              <DetalheDispositivo 
                devices={devices} 
                onRemoveDevice={handleRemoveDevice} 
                onToggleDevice={handleToggleDevice} 
              />
            } 
          />
          <Route path="/gerenciar" element={<Gerenciar />} /> 
          <Route path="/painel-solar" element={<DetalhePainelSolar />} /> {/* 📌 nova rota */}

          {/* Rotas principais com navbar */}
          <Route 
            path="/inicio" 
            element={<Inicio devices={devices} onToggleDevice={handleToggleDevice} />} 
          /> 
          <Route path="/gastos" element={<Gastos />} />
          <Route path="/assistente" element={<Assistente />} /> 
          <Route path="/perfil" element={<Perfil />} />
          <Route path="/mais" element={<Mais />} />
        </Routes>
      </div>
      
      {/* Navbar só aparece nas rotas principais */}
      {shouldShowNavbar && <Navbar />}
    </div>
  );
}

// O componente App envolve MainAppContent com Router
export default function App() {
  return (
    <Router>
      <AuthProvider>
        <MainAppContent />
      </AuthProvider>
    </Router>
  );
}
