using UnityEngine;
using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor.Animations;
#endif

public class AnimationLoopController : MonoBehaviour
{
    [SerializeField] private Animator animator;
    [SerializeField] private string isTrainingParamName = "isTraining";
    [SerializeField] private int defaultLoopCount = 8;
    [SerializeField] private List<string> ignoredStates = new List<string>();

    private Dictionary<string, int> stateLoopCounts = new Dictionary<string, int>();
    private Dictionary<string, int> currentLoops = new Dictionary<string, int>();
    private string currentStateName;
    private bool isTraining = false;

    private void Awake()
    {
        Init();
    }

    private void OnEnable()
    {
        if (animator != null)
        {
            SetupAnimatorBehaviours();
        }
    }

    private void Init()
    {
        animator = GetComponent<Animator>();
        if (animator == null)
        {
            Debug.LogError("animator가 null입니다.");
            return;
        }

#if UNITY_EDITOR
        // 에디터에서만 실행되는 코드
        AnimatorController controller = animator.runtimeAnimatorController as AnimatorController;
        if (controller != null)
        {
            foreach (AnimatorControllerLayer layer in controller.layers)
            {
                foreach (ChildAnimatorState state in layer.stateMachine.states)
                {
                    string stateName = state.state.name;
                    if (!ignoredStates.Contains(stateName))
                    {
                        stateLoopCounts[stateName] = defaultLoopCount;
                        currentLoops[stateName] = 0;
                    }
                }
            }
        }
#else
        // 런타임에서는 상태 이름을 동적으로 확인
        for (int i = 0; i < animator.layerCount; i++)
        {
            foreach (AnimatorClipInfo clipInfo in animator.GetCurrentAnimatorClipInfo(i))
            {
                string stateName = clipInfo.clip.name;
                if (!ignoredStates.Contains(stateName))
                {
                    stateLoopCounts[stateName] = defaultLoopCount;
                    currentLoops[stateName] = 0;
                }
            }
        }
#endif
    }

    private void SetupAnimatorBehaviours()
    {
#if UNITY_EDITOR
        AnimatorController controller = animator.runtimeAnimatorController as AnimatorController;
        if (controller != null)
        {
            foreach (AnimatorControllerLayer layer in controller.layers)
            {
                SetupBehavioursForStateMachine(layer.stateMachine);
            }
        }
#endif
    }

#if UNITY_EDITOR
    private void SetupBehavioursForStateMachine(AnimatorStateMachine stateMachine)
    {
        foreach (ChildAnimatorState state in stateMachine.states)
        {
            if (!ignoredStates.Contains(state.state.name))
            {
                AnimatorStateBehaviour behaviour = state.state.behaviours.Length > 0
                    ? (AnimatorStateBehaviour)state.state.behaviours[0]
                    : state.state.AddStateMachineBehaviour<AnimatorStateBehaviour>();

                behaviour.OnStateEnterEvent = OnStateEnter;
                behaviour.OnStateExitEvent = OnStateExit;
            }
        }

        foreach (ChildAnimatorStateMachine childStateMachine in stateMachine.stateMachines)
        {
            SetupBehavioursForStateMachine(childStateMachine.stateMachine);
        }
    }
#endif

    private void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        currentStateName = GetStateNameFromHash(stateInfo.shortNameHash);
        Debug.Log($"Entered state: {currentStateName}");
    }

    private void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        string stateName = GetStateNameFromHash(stateInfo.shortNameHash);
        if (currentLoops.ContainsKey(stateName))
        {
            currentLoops[stateName]++;
            Debug.Log($"{stateName} loop: {currentLoops[stateName]}");

            if (currentLoops[stateName] >= stateLoopCounts[stateName])
            {
                TransitionToTrainingState();
            }
        }
    }

    private string GetStateNameFromHash(int hash)
    {
        return animator.GetLayerName(hash);
    }

    private void TransitionToTrainingState()
    {
        isTraining = true;
        animator.SetBool(isTrainingParamName, isTraining);
        ResetLoopCounts();
        Debug.Log($"Transitioned to training state. isTraining: {isTraining}");
    }

    private void ResetLoopCounts()
    {
        foreach (var key in currentLoops.Keys)
        {
            currentLoops[key] = 0;
        }
    }

    public void SetAnimationState(bool isTrainingState)
    {
        isTraining = isTrainingState;
        animator.SetBool(isTrainingParamName, isTraining);
        ResetLoopCounts();
    }

    public void SetLoopCountForState(string stateName, int loopCount)
    {
        if (stateLoopCounts.ContainsKey(stateName))
        {
            stateLoopCounts[stateName] = loopCount;
        }
    }
}

public class AnimatorStateBehaviour : StateMachineBehaviour
{
    public System.Action<Animator, AnimatorStateInfo, int> OnStateEnterEvent;
    public System.Action<Animator, AnimatorStateInfo, int> OnStateExitEvent;

    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        OnStateEnterEvent?.Invoke(animator, stateInfo, layerIndex);
    }

    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        OnStateExitEvent?.Invoke(animator, stateInfo, layerIndex);
    }
}