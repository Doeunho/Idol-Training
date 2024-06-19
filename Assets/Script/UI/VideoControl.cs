using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Video;

public class VideoControl : MonoBehaviour
{
    public VideoPlayer videoPlayer;
    public RawImage rawImage;

    void Start()
    {
        if (videoPlayer == null || rawImage == null)
        {
            Debug.LogError("VideoPlayer 또는 RawImage가 할당되지 않았습니다.");
            return;
        }

        // VideoPlayer의 이벤트에 콜백 함수 등록
        videoPlayer.loopPointReached += OnVideoEnd;

        // VideoPlayer의 출력 텍스처를 RawImage에 설정
        rawImage.texture = videoPlayer.texture;

        // 동영상 재생 시작
        videoPlayer.Play();
    }

    void OnVideoEnd(VideoPlayer vp)
    {
        // 비디오가 끝났을 때 RawImage를 비활성화
        rawImage.gameObject.SetActive(false);
    }
}
