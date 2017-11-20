function IsVerified = Verify(Modulus, PublicExponent, Message, Signature)
    IsVerified = all(Message == NumberTheory.ModularExponentiation(Signature, PublicExponent, Modulus));
end