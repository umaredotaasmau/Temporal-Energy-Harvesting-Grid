import { describe, it, beforeEach, expect } from "vitest"

describe("Temporal Anomaly Detection Contract", () => {
  let mockStorage: Map<string, any>
  let nextAnomalyId: number
  
  beforeEach(() => {
    mockStorage = new Map()
    nextAnomalyId = 0
  })
  
  const mockContractCall = (method: string, args: any[] = []) => {
    switch (method) {
      case "report-anomaly":
        const [location, intensity] = args
        const id = nextAnomalyId++
        mockStorage.set(id, {
          detector: "tx-sender",
          location,
          intensity,
          detected_at: Date.now(),
        })
        return { success: true, value: id }
      case "get-anomaly":
        return { success: true, value: mockStorage.get(args[0]) }
      case "is-high-intensity-anomaly":
        const anomaly = mockStorage.get(args[0])
        return { success: true, value: anomaly ? anomaly.intensity > 80 : false }
      default:
        return { success: false, error: "Unknown method" }
    }
  }
  
  it("should report an anomaly", () => {
    const result = mockContractCall("report-anomaly", ["Time Square", 75])
    expect(result.success).toBe(true)
    expect(result.value).toBe(0)
  })
  
  it("should get an anomaly", () => {
    mockContractCall("report-anomaly", ["Time Square", 75])
    const result = mockContractCall("get-anomaly", [0])
    expect(result.success).toBe(true)
    expect(result.value.location).toBe("Time Square")
    expect(result.value.intensity).toBe(75)
  })
  
  it("should identify high intensity anomalies", () => {
    mockContractCall("report-anomaly", ["Time Square", 75])
    mockContractCall("report-anomaly", ["Stonehenge", 90])
    const result1 = mockContractCall("is-high-intensity-anomaly", [0])
    const result2 = mockContractCall("is-high-intensity-anomaly", [1])
    expect(result1.value).toBe(false)
    expect(result2.value).toBe(true)
  })
})

