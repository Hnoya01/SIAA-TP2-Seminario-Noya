package persistence;

/** Acceso a antecedentes para control de duplicidad por ventana (días). */
public interface RepositorioAntecedentes {
    /** true si hay al menos un antecedente dentro de la ventana. */
    boolean tieneDuplicidad(String afiliadoDni, String prestacionCodigo, int ventanaDias);

    /** cantidad de antecedentes dentro de la ventana. */
    int contarAntecedentes(String afiliadoDni, String prestacionCodigo, int ventanaDias);
}
