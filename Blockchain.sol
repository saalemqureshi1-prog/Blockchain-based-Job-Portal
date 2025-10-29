// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * Project: Blockchain-based Job Portal: Decentralized Career Connect
 * Description: A decentralized job portal where employers can post jobs and job seekers can apply.
 */

contract JobPortal {
    // Structure to represent a Job
    struct Job {
        uint256 id;
        address employer;
        string title;
        string description;
        uint256 salary;
        bool isActive;
    }

    // Structure to represent a Job Application
    struct Application {
        uint256 jobId;
        address applicant;
        string resumeHash; // IPFS hash or resume link
    }

    uint256 public jobCounter;
    mapping(uint256 => Job) public jobs;
    mapping(uint256 => Application[]) public jobApplications;

    event JobPosted(uint256 jobId, address employer, string title);
    event JobApplied(uint256 jobId, address applicant);

    // Function 1: Post a new job
    function postJob(string memory _title, string memory _description, uint256 _salary) public {
        jobCounter++;
        jobs[jobCounter] = Job(jobCounter, msg.sender, _title, _description, _salary, true);
        emit JobPosted(jobCounter, msg.sender, _title);
    }

    // Function 2: Apply to a job
    function applyJob(uint256 _jobId, string memory _resumeHash) public {
        require(jobs[_jobId].isActive, "Job not active");
        jobApplications[_jobId].push(Application(_jobId, msg.sender, _resumeHash));
        emit JobApplied(_jobId, msg.sender);
    }

    // Function 3: View applications for a specific job (Employer only)
    function viewApplications(uint256 _jobId) public view returns (Application[] memory) {
        require(jobs[_jobId].employer == msg.sender, "Only employer can view applications");
        return jobApplications[_jobId];
    }
}
