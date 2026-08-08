package gg.vape.api;

import java.net.Socket;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import javax.net.ssl.SSLEngine;
import javax.net.ssl.X509ExtendedTrustManager;

/**
 * Permissive X509 trust manager that accepts all certificates.
 * WARNING: This should only be used for development/testing purposes.
 * Using this in production exposes you to man-in-the-middle attacks.
 * This is now controlled by the "vape.allowInsecureSSL" system property.
 */
public final class ApiPermissiveX509ExtendedTrustManager
extends X509ExtendedTrustManager {
    @Override
    public void checkClientTrusted(X509Certificate[] certificateChain, String authType) {
        // Intentionally permissive for development - DO NOT USE IN PRODUCTION
    }

    @Override
    public void checkClientTrusted(X509Certificate[] certificateChain, String authType, Socket socket) throws CertificateException {
        // Intentionally permissive for development - DO NOT USE IN PRODUCTION
    }

    @Override
    public X509Certificate[] getAcceptedIssuers() {
        return new X509Certificate[0];
    }

    @Override
    public void checkServerTrusted(X509Certificate[] certificateChain, String authType) {
        // Intentionally permissive for development - DO NOT USE IN PRODUCTION
    }

    @Override
    public void checkServerTrusted(X509Certificate[] certificateChain, String authType, SSLEngine sslEngine) throws CertificateException {
        // Intentionally permissive for development - DO NOT USE IN PRODUCTION
    }

    @Override
    public void checkClientTrusted(X509Certificate[] certificateChain, String authType, SSLEngine sslEngine) throws CertificateException {
        // Intentionally permissive for development - DO NOT USE IN PRODUCTION
    }

    @Override
    public void checkServerTrusted(X509Certificate[] certificateChain, String authType, Socket socket) throws CertificateException {
        // Intentionally permissive for development - DO NOT USE IN PRODUCTION
    }
}
