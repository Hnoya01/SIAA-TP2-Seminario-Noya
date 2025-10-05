package application;

import domain.EstadoSolicitud;
import domain.Solicitud;

/**
 * Orquestador mínimo (stub).
 * En el prototipo sólo muestra la intención; la lógica real va en servicios/repositorios.
 */
public class ControlAutorizaciones {

    public void emitirAutorizacion(Solicitud s) {
        // Aquí validarías reglas, duplicidad, umbral, etc.
        System.out.println("Emitir autorización para " + s);
        // En la implementación real: cambiar estado a AUTORIZADA y registrar bitácora
        // repositorio.cambiarEstado(s.getId(), EstadoSolicitud.AUTORIZADA) ...
    }

    public void registrarRechazo(Solicitud s, String motivo) {
        System.out.println("Rechazo de " + s + " | Motivo: " + motivo);
        // En la implementación real: RECHAZADA + bitácora
    }

    public void anular(Solicitud s, String motivo) {
        System.out.println("Anulación de " + s + " | Motivo: " + motivo);
        // En la implementación real: ANULADA + bitácora
    }
}
