package domain;

/**
 * Enum alineado 1:1 con el ENUM de MySQL (tabla solicitud.estado).
 */
public enum EstadoSolicitud {
    EN_EVALUACION,
    SOLICITAR_DOC,
    EN_CORRECCION,
    ELEVADA,
    AUTORIZADA,
    RECHAZADA,
    ANULADA,
    INFORMAR_AFILIADO,
    ARCHIVADA
}
