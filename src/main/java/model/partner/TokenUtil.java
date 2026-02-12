package model.partner;

/*
 * Lois Poh 
 * 2429478
 */
import java.security.SecureRandom;

public class TokenUtil {
	// Defines the character set for token generation: alphanumeric, case-sensitive
	private static final String CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

	// Instantiates a single SecureRandom instance for the lifetime of the class
	private static final SecureRandom RNG = new SecureRandom();

	// Generates a random alphanumeric token of specified length
	public static String randomToken(int length) {

		// Allocates a StringBuilder with pre-determined capacity for efficiency
		StringBuilder sb = new StringBuilder(length);

		// Loops until the token reaches the required length
		for (int i = 0; i < length; i++) {

			// Selects a random character from the CHARS string and appends to builder
			sb.append(CHARS.charAt(RNG.nextInt(CHARS.length())));
		}

		// Returns the completed random token as a String
		return sb.toString();
	}
}
