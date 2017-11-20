function Ciphertext = Encrypt(Modulus, PublicExponent, Message)
    Ciphertext = NumberTheory.ModularExponentiation(Message, PublicExponent, Modulus);   
end

