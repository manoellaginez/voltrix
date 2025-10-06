// >>>>>>>>>>> PAGINA EM JSX

import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { fetchEnergia } from '../../endpoints/Api';

const FaArrowLeft = () => (
  <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" 
    viewBox="0 0 24 24" fill="none" stroke="currentColor" 
    strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M19 12H5"></path>
    <path d="M12 19l-7-7 7-7"></path>
  </svg>
);

export default function DetalhePainelSolar() {
  const navigate = useNavigate();

  const [ligado, setLigado] = useState(false);
  const [energia, setEnergia] = useState(null);
  const [loadingEnergia, setLoadingEnergia] = useState(true);
  const [erroEnergia, setErroEnergia] = useState(null);

  // Para inicializar `ligado` a partir da telemetria apenas na primeira carga
  const inicializadoLigado = useRef(false);

  useEffect(() => {
    let isMounted = true;

    const load = async () => {
      try {
        setLoadingEnergia(true);
        setErroEnergia(null);
        const data = await fetchEnergia("painel"); // trocar pelo ID real se necessário
        if (!isMounted) return;
        setEnergia(data || null);

        // inicializa `ligado` a partir da telemetria somente na primeira vez
        if (!inicializadoLigado.current) {
          const ligadoTelemetria = data?.ligado ?? data?.energia?.ligado;
          if (typeof ligadoTelemetria === 'boolean') {
            setLigado(ligadoTelemetria);
          }
          inicializadoLigado.current = true;
        }
      } catch (e) {
        if (isMounted) setErroEnergia(e.message || String(e));
      } finally {
        if (isMounted) setLoadingEnergia(false);
      }
    };

    load();
    const t = setInterval(load, 5000);
    return () => { isMounted = false; clearInterval(t); };
  }, []);

  const fmt = (n, digits = 3) => {
    if (n === null || n === undefined) return '—';
    const num = Number(n);
    if (Number.isNaN(num)) return '—';
    return num.toFixed(digits);
  };

  const watts = energia?.w_instantaneo;
  const kwhHoje = energia?.kwh_hoje;
  const kwhMes = energia?.kwh_mes;

  return (
    <div className="device-list-container" style={{ paddingTop: '20px' }}>
      {/* Topo com botão voltar */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '30px' }}>
        <button 
          onClick={() => navigate(-1)} 
          style={{ background: 'none', border: 'none', color: 'var(--cor-texto-claro)', fontSize: '20px', cursor: 'pointer' }}
        >
          <FaArrowLeft />
        </button>
      </div>

      <h1 style={{ fontSize: '30px', color: 'var(--cor-primaria)', marginBottom: '10px' }}>
        Painel solar
      </h1>
      <p style={{ color: 'var(--cor-texto-escuro)', fontSize: '16px' }}>
        Configuração e monitoramento do seu painel
      </p>

      {/* Switch de ligar/desligar */}
      <div 
        className={`device-card ${ligado ? 'active' : ''}`} 
        style={{ marginTop: '20px' }}
      >
        <div className="device-info">
          <h3 style={{ color: 'var(--cor-texto-claro)' }}>Status</h3>
          <p style={{ color: ligado ? 'var(--cor-texto-claro)' : 'var(--cor-texto-escuro)' }}>
            {ligado ? 'LIGADO' : 'DESLIGADO'}
          </p>
        </div>

        <div 
          className="device-toggle"
          onClick={() => setLigado(!ligado)}
          style={{ cursor: 'pointer' }}
        >
          <div className={`device-toggle-circle ${ligado ? 'active' : ''}`}></div>
        </div>
      </div>

      {/* Card de consumo */}
      <div className="consumption-card" style={{ marginTop: '20px' }}>
        <h3 className="card-label">Informações de uso</h3>

        {loadingEnergia && <p style={{ color: 'var(--cor-texto-claro)', marginTop: 10 }}>Carregando telemetria…</p>}
        {erroEnergia && !loadingEnergia && (
          <p style={{ color: 'var(--cor-primaria)', marginTop: 10 }}>Erro: {erroEnergia}</p>
        )}

        {!loadingEnergia && !erroEnergia && (
          <>
            <p style={{ color: 'var(--cor-texto-claro)', margin: '10px 0' }}>
              <strong>Potência agora:</strong> {fmt(watts, 2)} W
            </p>
            <p style={{ color: 'var(--cor-texto-claro)', margin: '10px 0' }}>
              <strong>Hoje:</strong> {fmt(kwhHoje, 3)} kWh
            </p>
            <p style={{ color: 'var(--cor-texto-claro)' }}>
              <strong>Mês:</strong> {fmt(kwhMes, 3)} kWh
            </p>
          </>
        )}
      </div>
    </div>
  );
}
