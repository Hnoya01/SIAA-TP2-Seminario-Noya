package domain;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Stub de dominio alineado con la tabla `solicitud`:
 *  id (BIGINT), fecha (DATETIME), orden_fecha (DATE),
 *  estado (ENUM), afiliado_dni (VARCHAR), prestador_id (BIGINT), version (INT).
 */
public class Solicitud {

    private long id;                      // solicitud.id
    private LocalDateTime fecha;          // solicitud.fecha (DEFAULT CURRENT_TIMESTAMP)
    private LocalDate ordenFecha;         // solicitud.orden_fecha (puede ser null)
    private EstadoSolicitud estado;       // solicitud.estado
    private String afiliadoDni;           // solicitud.afiliado_dni
    private long prestadorId;             // solicitud.prestador_id
    private int version;                  // solicitud.version (control optimista)

    public Solicitud(long id,
                     LocalDateTime fecha,
                     LocalDate ordenFecha,
                     EstadoSolicitud estado,
                     String afiliadoDni,
                     long prestadorId,
                     int version) {
        this.id = id;
        this.fecha = fecha;
        this.ordenFecha = ordenFecha;
        this.estado = estado;
        this.afiliadoDni = afiliadoDni;
        this.prestadorId = prestadorId;
        this.version = version;
    }

    // Getters (suficiente para el prototipo)
    public long getId() { return id; }
    public LocalDateTime getFecha() { return fecha; }
    public LocalDate getOrdenFecha() { return ordenFecha; }
    public EstadoSolicitud getEstado() { return estado; }
    public String getAfiliadoDni() { return afiliadoDni; }
    public long getPrestadorId() { return prestadorId; }
    public int getVersion() { return version; }

    @Override
    public String toString() {
        return "Solicitud #" + id + " [" + estado + "] afiliado=" + afiliadoDni + " prestadorId=" + prestadorId;
    }
}
