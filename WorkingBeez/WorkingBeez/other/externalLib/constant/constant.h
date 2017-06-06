//
//  constant.h
//  NMT
//
//  Created by Bhavesh on 31/08/15.
//  Copyright (c) 2015 Haresh  Vavadiya. All rights reserved.
//

#ifndef sikka_constant_h
#define sikka_constant_h

//API URL
#define API_MAIN_URL @"http://103.16.129.184:3030" //Live
//#define API_MAIN_URL @"http://103.16.129.184:5051" //Local

#define BEEZ_EMAIL @"workingbeez.live@gmail.com"

#define DEVICE_TOKEN @"device_token"
#define JID @"JUserName"
#define Payment_Message @"You have not provided your payment detail yet, please add."

#define SHARE_TEXT @"Download our app and start getting jobs. All the best.\nApple: https://itunes.apple.com/us/app/wokingbeez-live/id1216057663?ls=1&mt=8\nAndroid: https://play.google.com/store/apps/details?id=com.app.workingbeez"
#define ALERT_TITLE @"WorkingBeez"
#define ERROR_MESSAGE @"could not connect to server or check your internet connectivity and try again"


#define XMPP_HOST @"103.16.129.184"
#define ABN_MESSAGE @"This ABN is not valid"
#define SEEKER_PAY_INOF @"As per Terms, 20% Platform Service Fee will be deducted from your earning."
#define RATING_INFO @"This will adversely affect your rating and you may not be eligible to work on the platform."



#define RATING_INFO_seeker @"If you terminate the running job: (a) you will not get paid for this job and/or (b) your rating will be affected & your account may be suspended. Want to proceed?"
#define poster_abort @"Terminating the running job will affect your rating and/or you may be charged penalty. Want to proceed?"

#define seeker_Cancel @"Cancelling the accepted job will affect your rating and/or your account may be suspended. Want to proceed?"
#define poster_Cancel @"Cancelling the accepted job will affect your rating and/or you may be charged penalty. Want to proceed?"

#define location_message @"Your location service is disable, We need your location to start the job"


#define ABORT_JOB_MESSAGE @"Do you want to terminate this job?"
#define CANCEL_JOB_MESSAGE @"Do you want to cancel this job?"
#define START_JOB_MESSAGE @"Do you want to start this job?"

#define SEVERING_MESSAGE @"Currently we are not severing in your area. We will launch soon"
#define SEVERING_MESSAGE_REG @"Currently we are severing only in Australia."



//FONT
#define font_openSans_regular @"OpenSans"
#define font_openSans_Italic @"OpenSans-Italic"
#define ABN_SECRET @"92d728e5-3a71-4d47-aeca-4ded28063fb8"
#define GoogleAutocompleteKey @"AIzaSyD9TRx2JM2e9SuiM0jPOvdUlpCNq9H-yLA"//"AIzaSyC4VQVvQ2vgSBmr88q7rZ_JoeskGYqI6w4"

#define Google_Client_ID @"727332602536-cpi3um978thcdd1rpp1kf7ns7dp7ig9o.apps.googleusercontent.com"
#define ITUNE_LINK @"https://itunes.apple.com/us/app/wokingbeez-live/id1216057663?ls=1&mt=8"

//API Name

//Seeker Register
#define API_GET_ALL_CATEGPRY @"GetAllCategory"
#define API_GET_ALL_JOB_TITLE @"GetAllTitle"
#define API_GET_ALL_CERTIFICATES @"GetAllCertificate"
#define API_GET_ALL_SKILLS @"GetAllSkill"
#define API_GET_ALL_ID_PROOF @"GetAllIDProof"
#define AddTempImage @"AddTempImage"
#define CHECK_ABN @"AbnDetails.aspx"

#define API_LOGIN @"Login"
#define API_SEEKER_REGISTER @"SeekerRegistration"
#define API_POSTER_REGISTER @"PosterRegistration"
#define API_POSTER_EDIT @"PosterProfileEdit"
#define API_SEEKER_EDIT @"SeekerProfilEdit"
#define API_ADD_PROFILE_PIC @"AddProfilePicture"
#define API_CheckDataExist @"CheckDataExist"

#define API_GET_DASHBOARD_DATA @"GetDashboardData"
#define API_SetSeekerAvailability @"SetSeekerAvailability"
#define API_CreateJobPost @"CreateJobPost"

#define API_GetUserSettings @"GetUserSettings"
#define API_SetUserSettings @"SetUserSettings"
#define API_CreatePosterLocation @"CreatePosterLocation"
#define API_DeletePosterLocation @"DeletePosterLocation"


#define API_GetAllWorkingRight @"GetAllWorkingRight"

#define API_ForgotPassword @"ForgotPassword"
#define API_ChangePassword @"ChangePassword"
#define API_DeleteIDProofs @"DeleteIDProofs"

#define API_GetPostHistory @"GetPostHistory"
#define API_JobProfileForPoster @"JobProfileForPoster"

//All job status Poster
#define API_GetPosterMatchingJobs @"GetPosterMatchingJobs"
#define API_GetPosterInvitedJobs @"GetPosterInvitedJobs"
#define API_GetPosterAppliedJobs @"GetPosterAppliedJobs"
#define API_GetPosterAcceptedJobs @"GetPosterAcceptedJobs"
#define API_GetPosterRunningJobs @"GetPosterRunningJobs"
#define API_GetAllSaveProfiles @"GetAllSaveProfiles"
#define API_GetPosterPendingPayments @"GetPosterPendingPayments"
#define API_SaveProfile @"SaveProfile"
#define API_InviteSeeker @"InviteSeeker"
#define API_GetPosterCompletedJobs @"GetPosterCompletedJobs"

//All job status Seeker
#define API_GetSeekerMatchingJobs @"GetSeekerMatchingJobs"
#define API_GetSeekerAppliedJobs @"GetSeekerAppliedJobs"
#define API_GetSeekerAcceptedJobs @"GetSeekerAcceptedJobs"
#define API_GetSeekerRunningJobs @"GetSeekerRunningJobs"
#define API_GetSeekerInvitedJobs @"GetSeekerInvitedJobs"
#define API_GetSeekerPendingPayments @"GetSeekerPendingPayments"
#define API_GetAllSaveJobProfiles @"GetAllSaveJobProfiles"
#define API_SavePosterJobProfile @"SavePosterJobProfile"
#define API_AppliedJob @"AppliedJob"
#define API_AcceptJob @"AcceptJob"
#define API_PlayJob @"PlayJob"
#define API_GetSeekerCompletedJobs @"GetSeekerCompletedJobs"
#define API_AccepteJobForPoster @"AccepteJobForPoster"


#define API_GetRosterDetails @"GetRosterDetails"
#define API_GetRosterDateDetails @"GetRosterDateDetails"
#define API_GetRosterDateDetails @"GetRosterDateDetails"

//Job Detail
#define API_JobPostProfile @"JobPostProfile"
#define API_GET_SEEKER_PROFILE @"GetSeekerProfile"
#define API_GET_POSTER_PROFILE @"GetPosterProfile"
#define API_GetCalender @"GetCalender"
#define API_GetRosterCalender @"GetRosterCalender"


#define API_GetOtherJobs @"GetOtherJobs"
#define API_GetOtherJobDetail @"GetOtherJobDetail"
#define API_GetAllCancelReason @"GetAllCancelReason"
#define API_CancelJob @"CancelJob"
#define API_AbortJob @"AbortJob"
#define API_SetRosterExtendsTime @"SetRosterExtendsTime"
#define API_RateAndReviewJob @"RateAndReviewJob"

#define API_GetNotes @"GetNotes"
#define API_CreateNote @"CreateNote"
#define API_DeleteNote @"DeleteNote"

#define API_SetUserLocation @"SetUserLocation"

#define API_GetCard @"GetCard"
#define API_SaveCard @"SaveCard"
#define API_SetCardDefault @"SetCardDefault"
#define API_DeleteCard @"DeleteCard"
#define API_SaveSeekerStripeInfomation @"SaveSeekerStripeInfomation"
#define API_CompleteJob @"CompleteJob"
#define API_SaveMesaage @"SaveMesaage"
#define API_GetMessageDetailList @"GetMessageDetailList"
#define API_GetMessageList @"GetMessageList"
#define API_GetNotificationList @"GetNotificationList"
#define API_MatchSeeker @"MatchSeeker"
#define API_Logout @"Logout"

#define API_CreateJobPostUsingOlderJob @"CreateJobPostUsingOlderJob"
#define API_CreateJobPostUsingInvitedSeeker @"CreateJobPostUsingInvitedSeeker"
#define API_HelpSupport @"HelpSupport"
#define API_GetInvoice @"GetInvoice"

#endif
