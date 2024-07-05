using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.EventSystems;

public class CharacterClickEvent : MonoBehaviour
{
    [SerializeField] Camera _mainCamera;

    int _animCount;

    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = _mainCamera.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            if(Physics.Raycast(ray, out hit))
            {
                GameObject clickedObject = hit.collider.gameObject;
                if(clickedObject == null)
                {
                    return;
                }

                OnClickTargetGameObject(clickedObject);
            }
        }
    }

    private void OnClickTargetGameObject(GameObject gObj)
    {
        // gObj
        var characterAnimControl = gObj.GetComponent<CharacterAnimControll>();
        if(characterAnimControl != null)
        {
            characterAnimControl.PlaySpecificAnimation($"Idle_{_animCount}");
            _animCount++;

            _animCount = (_animCount > 2) ? 0 : _animCount;

        }
    }



    //캐릭터 클릭시 Idle 애니메이션 다른거 나오게, 대사도?

    public void Click_AnimationEvent()
    {
        Debug.Log("클릭됨");
    }
}

