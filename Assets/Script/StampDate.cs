using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class StampDate : MonoBehaviour
{
    public GameObject dialogueBox;      // 대화창 게임 오브젝트
    public Animator Stampanimator;           // 애니메이터 컴포넌트
    public string StamptriggerName;          // 활성화할 애니메이션 트리거 이름
    public GameObject StampgameObject;      // 활성화할 첫 번째 게임 오브젝트
    public GameObject CardgameObject;      // 활성화할 두 번째 게임 오브젝트
    public GameObject StampCard; // 추가로 활성화할 오브젝트1
    public GameObject Stampink; // 추가로 활성화할 오브젝트2
    public float delayBetweenActivations; // 오브젝트 활성화 간의 지연 시간
    public float delayBetweenActivations2; // 오브젝트 활성화 간의 지연 시간


    void Update()
    {
        if (Input.GetMouseButtonDown(0)) // 마우스 왼쪽 버튼 클릭 감지
        {
            CloseDialogueAndActivateObjects();
        }

    }

    void CloseDialogueAndActivateObjects()
    {
        // 대화창 비활성화
        dialogueBox.SetActive(false);

        // 애니메이션 트리거 활성화
        Stampanimator.SetTrigger(StamptriggerName);

        // 게임 오브젝트들 순차적으로 활성화
        StartCoroutine(ActivateObjectsInSequence());
    }

    IEnumerator ActivateObjectsInSequence()
    {
        // 첫 번째 게임 오브젝트 활성화
        StampgameObject.SetActive(true);
        CardgameObject.SetActive(true);
        yield return new WaitForSeconds(delayBetweenActivations);

        // 추가 게임 오브젝트1 활성화
        if (StampCard != null)
        {
            StampCard.SetActive(true);
            Stampink.SetActive(true);
            yield return new WaitForSeconds(delayBetweenActivations);
        }
    }
}
