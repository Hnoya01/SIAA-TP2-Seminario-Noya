package persistence;

/** Parámetros de negocio (topes, umbral de elevación, etc.). */
public interface RepositorioParametros {
    /** Tope anual de una prestación (ej.: sesiones de kinesiología). */
    int obtenerTope(String prestacionCodigo);

    /** Umbral monetario que obliga a elevar a Subgerencia. */
    double obtenerUmbralElevacion();
}
