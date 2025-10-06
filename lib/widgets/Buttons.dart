// >>>>>>>>>>> PAGINA EM JSX

export default function Buttons(props){

    const type = props.type;

    return(
        <button type={type}>{props.children}</button>
    )
}