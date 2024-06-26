####################################################################################
###############--------------- DESCRIPTIVE STATISTICS ---------------###############
####################################################################################

### In this script: 
# (1) Demographics
# (2) Psychiatric comorbidities
# (3) Task metrics
# (4) Questionnaire measures

# Set working directory
here::i_am("github/effort-study/code/analyses/1_descriptives.R")
setwd(here::here())

# source functions
source("github/effort-study/code/functions/helper_funs.R")

# source datasets
main_data <- readRDS("data/processed_data/main_study/online_data.RDS")
main_data_excl <- readRDS("data/processed_data/main_study/online_data_excl.RDS")

# load required packages
librarian::shelf(ggplot2, ggpubr, tidyverse, dplyr, stringr, purrr, here, janitor, MatchIt, writexl, lubridate, purrr, magrittr)

### (1) Demographics -----------------------------------------------

# Included sample

main_data$demographics %>% 
  summarise(N=n(), N_perc = (n()/994)*100, 
            mean_age = mean(age), sd_age = sd(age), min_age = min(age), max_age = max(age),
            median_ses = median(ses), iqr_upper_ses = quantile(ses, 0.25), iqr_lower_ses = quantile(ses, 0.75))

main_data$demographics %>% 
  tabyl(gender)

main_data$demographics %>% 
  tabyl(ethnicity)

# Excluded sample

main_data_excl$demographics %>% 
  summarise(N=n(), N_perc = (n()/994)*100, 
            mean_age = mean(age), sd_age = sd(age), min_age = min(age), max_age = max(age),
            median_ses = median(ses), iqr_upper_ses = quantile(ses, 0.25), iqr_lower_ses = quantile(ses, 0.75))

main_data_excl$demographics %>% 
  tabyl(gender)

main_data_excl$demographics %>% 
  tabyl(ethnicity)

### (2) Psychiatric comorbidities -----------------------------------------------

# Included sample

main_data$demographics %>% 
  summarise(N_psych_neurdev = sum(psych_neurdev), 
            N_psych_neurdev_prec = sum(psych_neurdev)/n())

# Depression
main_data$demographics$psych_neurdev_condition %>% 
  str_subset("Major depressive disorder|depression|Depression|MDD|mdd") %>% 
  length()
94 / 958

# Anxiety
main_data$demographics$psych_neurdev_condition %>% 
  str_subset("Social anxiety disorder|Generalised anxiety disorder") %>% 
  length()
195 / 958

# Anti-depressant use
main_data$demographics %>% 
  summarise(N_antid = sum(antidepressant, na.rm = TRUE), 
            N_antid_prec = sum(antidepressant, na.rm = TRUE)/n())

# Excluded sample

main_data_excl$demographics %>% 
  summarise(N_psych_neurdev = sum(psych_neurdev), 
            N_psych_neurdev_prec = sum(psych_neurdev)/n())

# Depression
main_data_excl$demographics$psych_neurdev_condition %>% 
  str_subset("Major depressive disorder|depression|Depression|MDD|mdd") %>% 
  length()
1 / 36

# Anxiety
main_data_excl$demographics$psych_neurdev_condition %>% 
  str_subset("Social anxiety disorder|Generalised anxiety disorder") %>% 
  length()
2 / 36

# Anti-depressant use
main_data_excl$demographics %>% 
  summarise(N_antid = sum(antidepressant, na.rm = TRUE), 
            N_antid_prec = sum(antidepressant, na.rm = TRUE)/n())

### (3) Task metrics -----------------------------------------------

# Included sample

# AM testing
main_data$game_meta %>%
  # temporarily change all days to the same, to get mean time
  mutate(start_time = update(start_time, year=2000, month=1, mday=1)) %>% 
  # adjust time stamps to summer time
  mutate(start_time = start_time + 60*60,
         end_time = end_time + 60*60) %>%
  filter(start_time > ymd_hms("2000-01-01 8:00:00") & start_time < ymd_hms("2000-01-01 11:59:59")) %>% 
  summarise(N_am_testing = n(), N_am_testing_perc = n()/958)

# PM testing
main_data$game_meta %>%
  # temporarily change all days to the same, to get mean time
  mutate(start_time = update(start_time, year=2000, month=1, mday=1)) %>% 
  # adjust time stamps to summer time
  mutate(start_time = start_time + 60*60,
         end_time = end_time + 60*60) %>%
  filter(start_time > ymd_hms("2000-01-01 18:00:00") & start_time < ymd_hms("2000-01-01 21:59:59")) %>% 
  summarise(N_am_testing = n(), N_am_testing_perc = n()/958)

# Duration
main_data$game_meta %>%
  mutate(time_diff = abs(difftime(start_time, end_time))) %>%
  summarise(mean_time_diff = mean(time_diff), sd_time_diff = sd(time_diff), 
            min_time_diff = min(time_diff), max_time_diff = max(time_diff))
  
# Mean clicking calibration
main_data$game_meta %>%
  summarise(mean_cali = mean(clicking_calibration), sd_cali = sd(clicking_calibration), 
            min_cali = min(clicking_calibration), max_cali = max(clicking_calibration))

# Change in clicking calibration
main_data$game %>%
  filter(phase == "calibration") %>% 
  group_by(subj_id) %>% 
  summarise(max_pre = max(clicks[1:3]),
            max_post = max(clicks[4])) %>% 
  summarise(mean_cali_chane = mean(max_pre - max_post),
            sd_cali_chane = sd(max_pre - max_post), 
            min_cali_chane = min(max_pre - max_post), 
            max_cali_chane = max(max_pre - max_post))

# Participants reports of decision-making process
main_data$questionnaire %>% 
  filter(game_response_2 == 1) %>% 
  select(game_response_text_2) %>% 
  print(n = 100)

# Excluded sample

# AM testing
main_data_excl$game_meta %>%
  # temporarily change all days to the same, to get mean time
  mutate(start_time = update(start_time, year=2000, month=1, mday=1)) %>% 
  # adjust time stamps to summer time
  mutate(start_time = start_time + 60*60,
         end_time = end_time + 60*60) %>%
  filter(start_time > ymd_hms("2000-01-01 8:00:00") & start_time < ymd_hms("2000-01-01 11:59:59")) %>% 
  summarise(N_am_testing = n(), N_am_testing_perc = n()/36)

# PM testing
main_data_excl$game_meta %>%
  # temporarily change all days to the same, to get mean time
  mutate(start_time = update(start_time, year=2000, month=1, mday=1)) %>% 
  # adjust time stamps to summer time
  mutate(start_time = start_time + 60*60,
         end_time = end_time + 60*60) %>%
  filter(start_time > ymd_hms("2000-01-01 18:00:00") & start_time < ymd_hms("2000-01-01 21:59:59")) %>% 
  summarise(N_pm_testing = n(), N_pm_testing_perc = n()/36)

# Duration
main_data_excl$game_meta %>%
  mutate(time_diff = abs(difftime(start_time, end_time))) %>%
  summarise(mean_time_diff = mean(time_diff), sd_time_diff = sd(time_diff), 
            min_time_diff = min(time_diff), max_time_diff = max(time_diff))

# Mean clicking calibration
main_data_excl$game_meta %>%
  summarise(mean_cali = mean(clicking_calibration), sd_cali = sd(clicking_calibration), 
            min_cali = min(clicking_calibration), max_cali = max(clicking_calibration))


### (4) Questionnaire measures -----------------------------------------------

# Included sample

# Psychiatric
main_data$questionnaire %>% 
            # SHAPS
  summarise(mean_shaps = mean(shaps_sumScore), sd_shaps = sd(shaps_sumScore), 
            min_shaps = min(shaps_sumScore), max_shaps = max(shaps_sumScore),
            # DARS
            mean_dars = mean(dars_sumScore), sd_dars = sd(dars_sumScore), 
            min_dars = min(dars_sumScore), max_dars = max(dars_sumScore),
            # AES
            mean_aes = mean(aes_sumScore), sd_aes = sd(aes_sumScore), 
            min_aes = min(aes_sumScore), max_aes = max(aes_sumScore)) %>% 
  print(width = Inf)

main_data$questionnaire %>% 
  janitor::tabyl(mdd_current)


# Circadian 
main_data$questionnaire %>% 
            # MEQ
  summarise(mean_meq = mean(meq_sumScore), sd_meq = sd(meq_sumScore), 
            min_meq = min(meq_sumScore), max_meq = max(meq_sumScore),
            # MCTQ
            mean_mctq = seconds_to_period(mean(period_to_seconds(hm(mctq_MSF_SC)), na.rm = TRUE)), 
            sd_mctq = seconds_to_period(sd(period_to_seconds(hm(mctq_MSF_SC)), na.rm = TRUE)), 
            min_mctq = seconds_to_period(min(period_to_seconds(hm(mctq_MSF_SC)), na.rm = TRUE)), 
            max_mctq = seconds_to_period(max(period_to_seconds(hm(mctq_MSF_SC)), na.rm = TRUE))) %>% 
  print(width = Inf)

# Metabolic
main_data$questionnaire %>% 
            # BMI
  summarise(mean_bmi = mean(bmi_result, na.rm = TRUE), sd_bmi = sd(bmi_result, na.rm = TRUE), 
            min_bmi = min(bmi_result, na.rm = TRUE), max_bmi = max(bmi_result, na.rm = TRUE),
            # FINDRISC
            mean_findrisc = mean(findrisc_sumScore), sd_findrisc = sd(findrisc_sumScore), 
            min_findrisc = min(findrisc_sumScore), max_findrisc = max(findrisc_sumScore)) %>% 
  print(width = Inf)


# Correlation matix between questionnare measures
cor_matrix <- main_data$questionnaire %>%
  mutate(mctq_MSF_SC = period_to_seconds(hm(mctq_MSF_SC))) %>%
  select(shaps_sumScore, dars_sumScore, aes_sumScore,
         meq_sumScore, mctq_MSF_SC, bmi_result, findrisc_sumScore) %>%
  # Standardize questionnaire data (to be between 0 and 1) 
  mutate_all(rescale) %>%
  # transform dars and aes to be interpretable in the same direction as the shaps (and in line with main result reporting)
  mutate(aes_sumScore = 1-aes_sumScore, 
         dars_sumScore = 1-dars_sumScore) %>%
  mutate(meq_sumScore = 1-meq_sumScore) %>% 
  cor(use="pairwise.complete.obs")

cor_p_matrix <- main_data$questionnaire %>%
  mutate(mctq_MSF_SC = period_to_seconds(hm(mctq_MSF_SC))) %>%
  select(shaps_sumScore, dars_sumScore, aes_sumScore,
         meq_sumScore, mctq_MSF_SC, bmi_result, findrisc_sumScore) %>%
  corrplot::cor.mtest() %>% 
  .$p 

cor_p_matrix <- melt(cor_p_matrix) 

melted_corr_mat <- melt(cor_matrix) %>% 
  add_column("p" = cor_p_matrix$value) %>%
  add_column(label = case_when(.$p <= 0.05 & .$p > 0.01 ~ "*",
                               .$p <= 0.01 & .$p > 0.001 ~ "**",
                               .$p <= 0.001 ~ "***", 
                               .default = ""))
# head(melted_corr_mat)

# plotting the correlation heatmap
ggplot(data = melted_corr_mat, aes(x = Var1, y = Var2,
                                   fill = value, label = label)) + 
  geom_tile() +
  geom_text() + 
  scale_fill_gradient(low = "white", high = "#5B9BD5", limits = c(-0.1, 1)) +
  theme(legend.position = "right",
        plot.title = element_text(size = 13),
        axis.title = element_blank(),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10),
        legend.title = element_blank(),
        legend.text = element_text(size = 13)) +
  scale_x_discrete(labels = c("SHAPS", "DARS", "AES", "MEQ", "MCTQ", "BMI", "FINDRISC")) +
  scale_y_discrete(labels = c("SHAPS", "DARS", "AES", "MEQ", "MCTQ", "BMI", "FINDRISC")) 
  


# Excluded sample

# Psychiatric
main_data_excl$questionnaire %>% 
  # SHAPS
  summarise(mean_shaps = mean(shaps_sumScore), sd_shaps = sd(shaps_sumScore), 
            min_shaps = min(shaps_sumScore), max_shaps = max(shaps_sumScore),
            # DARS
            mean_dars = mean(dars_sumScore), sd_dars = sd(dars_sumScore), 
            min_dars = min(dars_sumScore), max_dars = max(dars_sumScore),
            # AES
            mean_aes = mean(aes_sumScore), sd_aes = sd(aes_sumScore), 
            min_aes = min(aes_sumScore), max_aes = max(aes_sumScore)) %>% 
  print(width = Inf)

# Circadian 
main_data_excl$questionnaire %>% 
  # MEQ
  summarise(mean_meq = mean(meq_sumScore), sd_meq = sd(meq_sumScore), 
            min_meq = min(meq_sumScore), max_meq = max(meq_sumScore),
            # MCTQ
            mean_mctq = seconds_to_period(mean(period_to_seconds(hm(mctq_MSF_SC)), na.rm = TRUE)), 
            sd_mctq = seconds_to_period(sd(period_to_seconds(hm(mctq_MSF_SC)), na.rm = TRUE)), 
            min_mctq = seconds_to_period(min(period_to_seconds(hm(mctq_MSF_SC)), na.rm = TRUE)), 
            max_mctq = seconds_to_period(max(period_to_seconds(hm(mctq_MSF_SC)), na.rm = TRUE))) %>% 
  print(width = Inf)

# Metabolic
main_data_excl$questionnaire %>% 
  # BMI
  summarise(mean_bmi = mean(bmi_result, na.rm = TRUE), sd_bmi = sd(bmi_result, na.rm = TRUE), 
            min_bmi = min(bmi_result, na.rm = TRUE), max_bmi = max(bmi_result, na.rm = TRUE),
            # FINDRISC
            mean_findrisc = mean(findrisc_sumScore), sd_findrisc = sd(findrisc_sumScore), 
            min_findrisc = min(findrisc_sumScore), max_findrisc = max(findrisc_sumScore)) %>% 
  print(width = Inf)







