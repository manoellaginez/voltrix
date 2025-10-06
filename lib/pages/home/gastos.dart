// >>>>>>>>>>> PAGINA EM JSX

import React from 'react';
import { useNavigate } from 'react-router-dom'; // Importar useNavigate para a Assistente

// Ícone de Dólar ($) (Mantido, mas não usado no título)
const FaDollarSign = ({ style = {} }) => (
  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round" style={style}>
    <line x1="12" y1="1" x2="12" y2="23"></line>
    <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
  </svg>
);

// Ícone de Filtro
const FaFilter = ({ style = {} }) => (
  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
    <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon>
  </svg>
);

// Ícone de Gráfico de Linha
const FaLineChart = ({ style = {} }) => (
  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
  </svg>
);

// ÍCONE DE CALENDÁRIO (Para Projeção Mensal - Movido para o topo)
const FaCalendar = ({ style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
        <line x1="16" y1="2" x2="16" y2="6"></line>
        <line x1="8" y1="2" x2="8" y2="6"></line>
        <line x1="3" y1="10" x2="21" y2="10"></line>
    </svg>
);

// NOVO ÍCONE: Ícone de Assistente/Bot
const FaRobot = ({ style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <path d="M10 9V5a2 2 0 0 1 4 0v4"></path>
        <path d="M15.4 15.4c.8-.8.8-2.2 0-3-.8-.8-2.2-.8-3 0-.8.8-.8 2.2 0 3z"></path>
        <rect x="2" y="7" width="20" height="16" rx="2"></rect>
        <path d="M6 14h12"></path>
    </svg>
);


// Componente principal da página de Gastos
export default function Gastos() {
  const navigate = useNavigate(); // Hook para navegação

  // Estilos CSS críticos movidos para um bloco style isolado (para dimensão)
  const buttonStyles = `
    /* APENAS ESTILOS PARA CORRIGIR A FONTE E REMOVER O BRILHO DO BOTÃO */
    .filter-button {
        font-family: 'Inter', sans-serif !important; 
        box-shadow: none !important; 
        outline: none !important;
        border: none !important;
        /* Garante que o hover/focus não adicione brilho */
        &:focus {
            box-shadow: none !important;
            outline: none !important;
        }
    }
    
    .filter-button.active {
        box-shadow: 0 4px 8px rgba(230, 0, 18, 0.3) !important;
    }
    
    /* --- CORREÇÃO ADICIONADA: Forçar a fonte Inter no botão ACESSAR ASSISTENTE --- */
    .assistant-card button {
        font-family: 'Inter', sans-serif !important;
    }

    .summary-cards-container, .additional-info-cards {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 15px;
    }
    
    /* Media query para adaptar o layout para uma coluna em telas pequenas */
    @media (max-width: 640px) {
        .summary-cards-container, .additional-info-cards {
            grid-template-columns: 1fr; /* Volta para uma coluna em telas pequenas */
        }
    }
  `;

  // Definindo as variáveis CSS para uso no estilo inline (necessário em alguns pontos)
  const primaryColor = 'var(--cor-primaria)';
  const textColor = 'var(--cor-texto-claro)';
  const secondaryTextColor = 'var(--cor-texto-escuro)';

  // Estado (simulado) para o filtro de tempo
  const [activeTimeFilter, setActiveTimeFilter] = React.useState('Hoje');

  const handleTimeFilter = (filter) => {
    setActiveTimeFilter(filter);
  };
    
    // Função para navegar para a Assistente
    const handleGoToAssistant = () => {
        // Implementação futura da navegação para a Assistente
        navigate('/assistente'); 
    };

  return (
    <div 
        className="gastos-page-container" 
        style={{ 
            padding: '20px 15px', 
            margin: '0 auto', 
            backgroundColor: 'white', 
            fontFamily: 'Inter, sans-serif' // Garante fonte no contêiner principal
        }}
    >
        {/* INJEÇÃO DE ESTILO MÍNIMA: Apenas para garantir a fonte e o estilo dos botões de filtro */}
        <style>{buttonStyles}</style>
      {/* CABEÇALHO DA PÁGINA */}
      <div className="page-header" style={{ paddingBottom: '15px', marginBottom: '20px' }}>
        <h1 style={{ color: primaryColor, fontSize: '28px', margin: '0 0 5px' }}>
                    Gastos
        </h1>
        <p style={{ color: secondaryTextColor, fontSize: '17px', margin: 0 }}>
          Monitore seus custos de energia
        </p>
      </div>

      {/* FILTRO DE TEMPO (Ajustado para ser maior e proporcional) */}
      <div className="time-filter-container" style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '10px', marginBottom: '25px' }}>
        {['HOJE', 'SEMANA', 'MÊS'].map(filter => (
          <button
            key={filter}
            className={`filter-button ${activeTimeFilter === filter ? 'active' : ''}`}
            onClick={() => handleTimeFilter(filter)}
            style={{ 
              padding: '12px 0', /* Aumentado o padding vertical */
              backgroundColor: activeTimeFilter === filter ? primaryColor : 'var(--cor-fundo-secundario)',
              color: activeTimeFilter === filter ? 'white' : secondaryTextColor,
                            fontSize: '16px', /* Aumentado a fonte para destaque */
                            fontWeight: '600',
                            borderRadius: '10px' /* Aumentado o arredondamento */
            }}
          >
            {filter}
          </button>
        ))}
      </div>

      {/* CARDS DE RESUMO (Gastos Total e Hoje) */}
      <div className="summary-cards-container" style={{ marginBottom: '20px' }}>
        
        {/* Gasto Total */}
        <div className="summary-card" style={{ background: 'var(--cor-fundo-secundario)', padding: '15px', borderRadius: '12px', boxShadow: '0 4px 10px rgba(0, 0, 0, 0.05)' }}>
          <p className="card-label" style={{ fontSize: '13px', color: secondaryTextColor, margin: '0 0 5px 0' }}>Gasto total</p>
          <h2 className="card-value" style={{ color: textColor, fontSize: '24px', fontWeight: 'bold', margin: 0 }}>R$ 150,50</h2>
          <p className="card-subtext" style={{ color: 'var(--cor-sucesso)', display: 'flex', alignItems: 'center', fontSize: '13px' }}>
            <FaLineChart style={{ fontSize: '12px', marginRight: '5px', strokeWidth: 2 }} />
            +4.2% no último período
          </p>
        </div>

        {/* Custo Hoje */}
        <div className="summary-card" style={{ background: 'var(--cor-fundo-secundario)', padding: '15px', borderRadius: '12px', boxShadow: '0 4px 10px rgba(0, 0, 0, 0.05)' }}>
          <p className="card-label" style={{ fontSize: '13px', color: secondaryTextColor, margin: '0 0 5px 0' }}>Hoje</p>
          <h2 className="card-value" style={{ color: textColor, fontSize: '24px', fontWeight: 'bold', margin: 0 }}>R$ 5,30</h2>
          <p className="card-subtext" style={{ color: secondaryTextColor, fontSize: '13px' }}>Custo ideal: R$ 6,00</p>
        </div>
      </div>

      {/* GRÁFICO (Gastos por Hora) */}
      <div className="graph-card" style={{ marginBottom: '20px', padding: '15px', borderRadius: '12px', backgroundColor: 'var(--cor-fundo-secundario)', boxShadow: '0 4px 10px rgba(0, 0, 0, 0.05)' }}>
        <div className="graph-header" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <h3 style={{ color: textColor, margin: 0, fontSize: '18px' }}>Gastos por hora</h3>
          <FaFilter style={{ color: secondaryTextColor, cursor: 'pointer', width: '20px', height: '20px' }} />
        </div>
        {/* Use uma altura flexível (e.g., aspect-ratio) para proporção */}
        <div className="graph-placeholder" style={{ 
          aspectRatio: '16 / 9', /* Mantém proporção de tela */
          width: '100%',
          background: 'white', 
          borderRadius: '8px', 
          margin: '15px 0',
          border: '1px dashed var(--cor-borda)', 
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'flex-end',
          paddingBottom: '10px'
        }}>
          {/* Placeholder para a linha vermelha do gráfico - Simulando a visualização */}
          <div style={{ 
            height: '5px', 
            width: '95%', 
            backgroundColor: primaryColor, 
            borderRadius: '3px',
            marginBottom: '5px'
          }}></div>
          <p style={{ textAlign: 'center', color: secondaryTextColor, fontSize: '12px' }}>00:00 - 23:59</p>
        </div>
      </div>

      {/* INFORMAÇÕES ADICIONAIS (Média e Projeção) */}
      <div className="additional-info-cards" style={{ marginBottom: '20px' }}>
        {/* Média Semanal */}
        <div className="info-card" style={{ background: 'var(--cor-fundo-secundario)', padding: '15px', borderRadius: '12px', boxShadow: '0 4px 10px rgba(0, 0, 0, 0.05)' }}>
          <p className="card-label" style={{ fontSize: '13px', color: secondaryTextColor, margin: '0 0 5px 0' }}>Média semanal</p>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <h2 className="card-value" style={{ color: textColor, margin: 0, fontSize: '24px', fontWeight: 'bold' }}>R$ 0,00</h2>
            <FaLineChart style={{ color: 'var(--cor-sucesso)', width: '24px', height: '24px' }} />
          </div>
        </div>

        {/* Projeção Mensal */}
        <div className="info-card" style={{ background: 'var(--cor-fundo-secundario)', padding: '15px', borderRadius: '12px', boxShadow: '0 4px 10px rgba(0, 0, 0, 0.05)' }}>
          <p className="card-label" style={{ fontSize: '13px', color: secondaryTextColor, margin: '0 0 5px 0' }}>Projeção mensal</p>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <h2 className="card-value" style={{ color: textColor, margin: 0, fontSize: '24px', fontWeight: 'bold' }}>R$ 0,00</h2>
            {/* Ícone de Calendário - Agora usando o componente definido no topo */}
            <FaCalendar style={{ color: secondaryTextColor }} />
          </div>
        </div>
      </div>

            {/* CARD DA ASSISTENTE (No final) */}
            <div className="info-card assistant-card" style={{ background: 'var(--cor-fundo-secundario)', padding: '15px', borderRadius: '12px', boxShadow: '0 4px 10px rgba(0, 0, 0, 0.05)', borderTop: '4px solid var(--cor-primaria)', marginBottom: '20px' }}>
                <div style={{ display: 'flex', alignItems: 'center', marginBottom: '8px' }}>
                    <FaRobot style={{ color: primaryColor, marginRight: '10px', width: '28px', height: '28px' }} />
                    <h3 style={{ color: textColor, margin: 0, fontSize: '18px' }}>Fale com a Voltrix Assistente</h3>
                </div>
                <p style={{ color: secondaryTextColor, fontSize: '14px', marginBottom: '15px' }}>
                    Quer um resumo do seu consumo no mês? A Assistente Voltrix lê e explica seus padrões de gastos.
                </p>
                <button 
                    onClick={handleGoToAssistant}
                    style={{
                        backgroundColor: primaryColor,
                        color: 'white',
                        padding: '10px 15px',
                        borderRadius: '8px',
                        border: 'none',
                        fontWeight: 'bold',
                        cursor: 'pointer',
                        width: '100%',
                        transition: 'background-color 0.3s'
                    }}
                >
                    ACESSAR ASSISTENTE
                </button>
            </div>
    </div>
  );
}