package gg.vape.account;

import gg.vape.account.MicrosoftSessionAuthenticator;
import java.security.cert.X509Certificate;
import javax.net.ssl.X509TrustManager;

/**
 * CRITICAL SECURITY WARNING: This trust manager accepts ALL SSL certificates without validation.
 * This is extremely dangerous and exposes users to man-in-the-middle attacks.
 * This should only be used for development/testing purposes with explicit user consent.
 * Disabled by default - set vape.allowInsecureSSL=true system property to enable.
 */
class PermissiveX509TrustManager
implements X509TrustManager {
    final MicrosoftSessionAuthenticator authenticator;

    PermissiveX509TrustManager(MicrosoftSessionAuthenticator authenticator) {
        this.authenticator = authenticator;
        if (!Boolean.getBoolean("vape.allowInsecureSSL")) {
            throw new SecurityException("Permissive SSL trust manager is disabled for security. " +
                    "Set -Dvape.allowInsecureSSL=true to enable (DANGEROUS - only for development)");
        }
        System.err.println("SECURITY WARNING: Using permissive SSL trust manager - this is extremely dangerous!");
    }

    @Override
    public void checkServerTrusted(X509Certificate[] certificateChain, String authType) {
        // Intentionally permissive - DO NOT USE IN PRODUCTION
    }

    @Override
    public void checkClientTrusted(X509Certificate[] certificateChain, String authType) {
        // Intentionally permissive - DO NOT USE IN PRODUCTION
    }

    @Override
    public X509Certificate[] getAcceptedIssuers() {
        return new X509Certificate[0];
    }
}
