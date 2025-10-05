package persistence;

import domain.EstadoSolicitud;
import domain.Solicitud;

public interface RepositorioSolicitudes {
    /** Alta de solicitud. Devuelve el id generado. */
    long guardar(Solicitud solicitud);

    /** Obtiene una solicitud por id (o null si no existe). */
    Solicitud obtener(long id);

    /** Guarda una decisión (estado + detalle para bitácora de la decisión). */
    void guardarDecision(long solicitudId, EstadoSolicitud nuevoEstado, String detalle);

    /** Cambia el estado (sin detalle). */
    void cambiarEstado(long solicitudId, EstadoSolicitud nuevoEstado);

    /** Registra un evento en la bitácora (append-only). */
    void registrarBitacora(long solicitudId, String actor, String evento, String detalle);
}
