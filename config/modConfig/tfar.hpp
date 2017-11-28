
// If set to true then Squad Leaders will be given LR radios
config_tfar_give_lr_radios_by_default = false;

// If set to true then only Squad Leaders get SR radios.
config_tfar_give_sr_radios_to_all = false;

radio_frequency_base_lr = 50;
radio_frequency_step_lr = 3.5;

radio_frequency_base_sr = 75;
radio_frequency_step_sr = 5;

lr_freq_ch_1 = format ["%1",radio_frequency_base_lr];
lr_freq_ch_2 = format ["%1",radio_frequency_base_lr + 1*radio_frequency_step_lr];
lr_freq_ch_3 = format ["%1",radio_frequency_base_lr + 2*radio_frequency_step_lr];
lr_freq_ch_4 = format ["%1",radio_frequency_base_lr + 3*radio_frequency_step_lr];
lr_freq_ch_5 = format ["%1",radio_frequency_base_lr + 4*radio_frequency_step_lr];
lr_freq_ch_6 = format ["%1",radio_frequency_base_lr + 5*radio_frequency_step_lr];
lr_freq_ch_7 = format ["%1",radio_frequency_base_lr + 6*radio_frequency_step_lr];
lr_freq_ch_8 = format ["%1",radio_frequency_base_lr + 7*radio_frequency_step_lr];

radio_frequencies_lr = [lr_freq_ch_1,
                        lr_freq_ch_2,
                        lr_freq_ch_3,
                        lr_freq_ch_4,
                        lr_freq_ch_5,
                        lr_freq_ch_6,
                        lr_freq_ch_7,
                        lr_freq_ch_8
];




sr_freq_ch_1 = format ["%1",radio_frequency_base_sr];
sr_freq_ch_2 = format ["%1",radio_frequency_base_sr + 1*radio_frequency_step_sr];
sr_freq_ch_3 = format ["%1",radio_frequency_base_sr + 2*radio_frequency_step_sr];
sr_freq_ch_4 = format ["%1",radio_frequency_base_sr + 3*radio_frequency_step_sr];
sr_freq_ch_5 = format ["%1",radio_frequency_base_sr + 4*radio_frequency_step_sr];
sr_freq_ch_6 = format ["%1",radio_frequency_base_sr + 5*radio_frequency_step_sr];
sr_freq_ch_7 = format ["%1",radio_frequency_base_sr + 6*radio_frequency_step_sr];
sr_freq_ch_8 = format ["%1",lr_freq_ch_1];

radio_frequencies_sr = [sr_freq_ch_1,
                        sr_freq_ch_2,
                        sr_freq_ch_3,
                        sr_freq_ch_4,
                        sr_freq_ch_5,
                        sr_freq_ch_6,
                        sr_freq_ch_7,
                        sr_freq_ch_8
];


