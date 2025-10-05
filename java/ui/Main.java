package ui;

import application.ControlAutorizaciones;
import domain.EstadoSolicitud;
import domain.Solicitud;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Punto de entrada de demo (sin UI gráfica): instancia una Solicitud coherente con la BD
 * y ejecuta un flujo mínimo para mostrar cómo se conectaría con la capa de aplicación.
 */
public class Main {
    public static void main(String[] args) {

        Solicitud demo = new Solicitud(
                1L,                           // id (ejemplo)
                LocalDateTime.now(),          // fecha
                LocalDate.now(),              // orden_fecha
                EstadoSolicitud.EN_EVALUACION,// estado inicial (DEFAULT en SQL)
                "30111222",                   // afiliado_dni
                1L,                           // prestador_id
                0                             // version (control optimista)
        );

        ControlAutorizaciones control = new ControlAutorizaciones();

        System.out.println("=== SIAA – Prototipo de consola ===");
        control.emitirAutorizacion(demo);
        control.registrarRechazo(demo, "Faltan adjuntos");
        control.anular(demo, "Solicitud anulada por el médico");
        System.out.println("=== Fin de demo ===");
    }
}
