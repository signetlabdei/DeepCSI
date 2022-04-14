function vtilde_matrix = Vtilde_NSS1(beamforming_angles, Nc, Nr, NSUBC_VALID, phi_bit, psi_bit)
 %% convert quantized values to angles
const1_phi = 1/2^(phi_bit-1);
const2_phi = 1/2^(phi_bit);
phi_11 = pi * (const2_phi + const1_phi * beamforming_angles(:, 1));
phi_21 = pi * (const2_phi + const1_phi * beamforming_angles(:, 2));

const1_psi = 1/2^(psi_bit+1);
const2_psi = 1/2^(psi_bit+2);
psi_21 = pi * (const2_psi + const1_psi * beamforming_angles(:, 3));
psi_31 = pi * (const2_psi + const1_psi * beamforming_angles(:, 4));

vtilde_matrix = zeros(Nc, NSUBC_VALID, Nr);
for s_i=1:NSUBC_VALID
    %% build D matrices (phi)
    D_1 = [exp(1i*phi_11(s_i)), 0, 0; 
           0, exp(1i*phi_21(s_i)), 0;
           0, 0, 1];

    %% build G matrices (psi)
    G_21 = [cos(psi_21(s_i)), sin(psi_21(s_i)), 0; 
            -sin(psi_21(s_i)), cos(psi_21(s_i)), 0;
            0, 0, 1];
    G_31 = [cos(psi_31(s_i)), 0, sin(psi_31(s_i)); 
            0, 1, 0;
            -sin(psi_31(s_i)), 0, cos(psi_31(s_i))];

    %% reconstruct V tilde matrix
    I_matrix = eye(Nr, Nc);
    Vtilde = D_1 * G_21.' * G_31.' * I_matrix;
    vtilde_matrix(:, s_i, :) = Vtilde.';

end