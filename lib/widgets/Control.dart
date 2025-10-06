// >>>>>>>>>>> PAGINA EM JSX

import React from 'react';

/**
 * Componente de controle de formulário reutilizável.
 * Assume que o estilo visual será gerenciado via 'className' pelo componente pai.
 */
export default function Control(props) {
    const { label: textLabel, type, placeholder, name, id, className, set, value } = props;

    return (
        <div className={className}>
            {/* O rótulo é mantido, mas será estilizado via CSS no Entre.jsx para parecer um placeholder ou ser escondido */}
            <label htmlFor={id}>{textLabel}</label>
            <input
                type={type}
                placeholder={placeholder}
                name={name}
                id={id}
                // Adicionando um className específico ao input para estilização
                className="control-input" 
                onChange={(e) => set(e.target.value)}
                value={value}
            />
        </div>
    );
}
