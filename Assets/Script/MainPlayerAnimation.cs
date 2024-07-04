using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainPlayerAnimation : MonoBehaviour
{
    //메인 캐릭터 애니메이션 (운동, 움직임)
    //컨트롤러는 동일한거 사용, 캐릭터 프리펩만 다르게


    public Transform playerTransform; // 플레이어의 Transform
    public Vector3 offset;            // 카메라와 플레이어 간의 오프셋
    public Transform cameraTransform; // 카메라의 Transform

    void LateUpdate()
    {
        if (playerTransform != null)
        {
            // 플레이어 위치에 오프셋을 더하여 카메라 위치를 설정
            transform.position = playerTransform.position + offset;
        }
    }


    void Update()
    {
        if (cameraTransform != null)
        {
            // 카메라의 위치를 바라보도록 회전
            Vector3 direction = cameraTransform.position - transform.position;
            direction.y = 0; // 수평 회전만 하도록 y축 방향은 제거
            transform.rotation = Quaternion.LookRotation(direction);
        }
    }

}
