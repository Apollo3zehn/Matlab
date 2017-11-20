function Message = Decrypt(Modulus, PrivateExponent, Ciphertext)
    Message = NumberTheory.ModularExponentiation(Ciphertext, PrivateExponent, Modulus);
end

