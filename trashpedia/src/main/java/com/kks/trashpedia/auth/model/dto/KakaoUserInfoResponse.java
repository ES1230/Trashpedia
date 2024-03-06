package com.kks.trashpedia.auth.model.dto;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class KakaoUserInfoResponse {
	private Long id;
	private Boolean has_signed_up;
	private String connected_at;
	private String synched_at;
	private KakaoProperties properties;
	private KakaoAccount kakao_account;
	
	@Getter
	public static class KakaoProperties{
		private String nickname;
		private String profile_image;
		private String thumbnail_image;
	}
	
	@Getter
	public static class KakaoAccount{
		private Boolean profile_needs_agreement;
		private KakaoProfile profile;
		private Boolean email_needs_agreement;
		private String email;
	}
	
	@Getter
	public static class KakaoProfile {
		private String nickname;
		private String thumbnail_image_url;
		private String profile_image_rul;
		private Boolean is_default_image;
	}
}
