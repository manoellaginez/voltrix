// >>>>>>>>>>> PAGINA EM JSX

import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { fetchEnergia } from '../../endpoints/Api';

const FaArrowLeft = () => (
  <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M19 12H5"></path>
    <path d="M12 19l-7-7 7-7"></path>
  </svg>
);

const FaTrash = () => (
  <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="3 6 5 6 21 6"></polyline>
    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
  </svg>
);

export default function DetalheDispositivo({ devices, onRemoveDevice, onToggleDevice }) {
  const { id } = useParams();
  const navigate = useNavigate();
  const [showModal, setShowModal] = useState(false);

  const [energia, setEnergia] = useState(null);
  const [loadingEnergia, setLoadingEnergia] = useState(true);
  const [erroEnergia, setErroEnergia] = useState(null);

  const dispositivoId = Number(id);
  const device = devices.find(d => d.id === dispositivoId);

  const titleColor = 'var(--cor-primaria)';

  useEffect(() => {
    if (!dispositivoId) return;
    let isMounted = true;

    const load = async () => {
      try {
        setLoadingEnergia(true);
        setErroEnergia(null);
        const data = await fetchEnergia(dispositivoId);
        const snap = data?.energia ?? data;
        if (isMounted) setEnergia(snap || null);
      } catch (e) {
        if (isMounted) setErroEnergia(e.message || String(e));
      } finally {
        if (isMounted) setLoadingEnergia(false);
      }
    };

    load();
    const t = setInterval(load, 5000); // recarrega a cada 5 segundos
    return () => { isMounted = false; clearInterval(t); };
  }, [dispositivoId]);

  if (!device) {
    return (
      <div className="device-list-container" style={{ padding: '20px' }}>
        Dispositivo não encontrado.
      </div>
    );
  }

  const handleRemove = () => setShowModal(true);

  // ALTERAÇÃO: ao confirmar, volta para a página anterior (navigate(-1))
  const confirmRemove = () => {
    onRemoveDevice(device.id);
    setShowModal(false);
    navigate(-1);
  };

  const cancelRemove = () => setShowModal(false);

  const fmt = (n, digits = 3) => {
    if (n === null || n === undefined) return '—';
    const num = Number(n);
    if (Number.isNaN(num)) return '—';
    return num.toFixed(digits);
  };

  const watts = energia?.w_instantaneo;
  const kwhHoje = energia?.kwh_hoje;
  const kwhMes = energia?.kwh_mes;
  const ligado = energia?.ligado;

  return (
    <div className="device-list-container" style={{ paddingTop: '20px' }}>
      {/* --- INJEÇÃO DE ESTILO: CORRIGE A FONTE DOS BOTÕES DO MODAL (ESTILO MÍNIMO) --- */}
      <style jsx="true">{`
        .add-device-button { outline: none !important; }
        .add-device-button:focus { box-shadow: none !important; }
      `}</style>

      {/* Modal de Confirmação */}
      {showModal && (
        <div className="modal-overlay">
          <div className="modal-content">
            <h3>Confirmar remoção</h3>
            <p>Tem certeza que deseja remover o dispositivo "{device.name}"?</p>
            <div className="modal-actions">
              <button
                onClick={confirmRemove}
                className="add-device-button"
                style={{ backgroundColor: 'var(--cor-primaria)', width: '48%', marginRight: '4%', fontFamily: 'Inter, sans-serif' }}
              >
                Remover
              </button>
              <button
                onClick={cancelRemove}
                className="add-device-button"
                style={{ backgroundColor: '#a6a6a6', width: '48%', fontFamily: 'Inter, sans-serif' }}
              >
                Cancelar
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Topo */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '30px' }}>
        <button onClick={() => navigate(-1)} style={{ background: 'none', border: 'none', color: 'var(--cor-texto-claro)', fontSize: '20px', cursor: 'pointer' }}>
          <FaArrowLeft />
        </button>
        <button onClick={handleRemove} style={{ background: 'none', border: 'none', color: 'var(--cor-primaria)', fontSize: '20px', cursor: 'pointer' }}>
          <FaTrash />
        </button>
      </div>

      <h1 style={{ fontSize: '30px', color: titleColor, marginBottom: '10px' }}>{device.name}</h1>
      <p style={{ color: 'var(--cor-texto-escuro)', fontSize: '16px' }}>Local: {device.room} | Tipo: {device.type}</p>

      <div className={`device-card ${device.status ? 'active' : ''}`} style={{ marginTop: '20px' }}>
        <div className="device-info">
          <h3 style={{ color: 'var(--cor-texto-claro)' }}>Status</h3>
          <p style={{ color: device.status ? 'var(--cor-texto-claro)' : 'var(--cor-texto-escuro)' }}>
            {device.status ? 'LIGADO' : 'DESLIGADO'}
          </p>
          {ligado !== undefined && ligado !== null && (
            <p style={{ color: 'var(--cor-texto-claro)', marginTop: 6 }}>
              (Tapo: {ligado ? 'Ligado' : 'Desligado'})
            </p>
          )}
        </div>

        <div className="device-toggle" onClick={() => onToggleDevice(device.id)}>
          <div className="device-toggle-circle"></div>
        </div>
      </div>

      <div className="consumption-card" style={{ marginTop: '20px' }}>
        <h3 className="card-label">Informações de Uso</h3>

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
